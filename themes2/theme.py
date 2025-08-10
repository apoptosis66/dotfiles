# /// script
# dependencies = [
#   "jinja2"
# ]
# ///

# theme.py
# Usage: uv run theme.py -t <theme_name>
# This script reads a JSON configuration file, then uses the data to render
# a list of Jinja2 templates and save the output to specified files.

import argparse
import json
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

config_path = Path.home() / Path(".config/themes2")
themes_path = config_path / Path("themes")
templates_path = config_path / Path("templates")


def strip_filter(text):
    return text.lstrip("#")


def render_templates_from_theme(theme_name, templates_name):
    """
    Renders Jinja2 templates from a specified theme directory.

    Args:
        theme_name (str): The name of the theme json file without extension.
        templates_name (str): The name the templates json file without extension.
    """
    theme_file_path = themes_path / f"{theme_name}.json"
    templates_file_path = templates_path / f"{templates_name}.json"

    # Check files exist
    if not theme_file_path.is_file():
        print(f"Error: The theme configuration file '{theme_file_path}' was not found.")
        return

    if not templates_file_path.is_file():
        print(f"Error: The templetes configuration file '{templates_file_path}' was not found.")
        return

    try:
        # Load the configuration json files
        with open(theme_file_path, "r") as f:
            theme_data = json.load(f)

        with open(templates_file_path, "r") as f:
            templates_data = json.load(f)

        if not templates_data:
            print("No templates found in the configuration file.")
            return

        # Set up the Jinja2 environment to load templates from the specified directory
        env = Environment(loader=FileSystemLoader(templates_path), trim_blocks=True, lstrip_blocks=True)

        # Register custom filters
        env.filters["strip"] = strip_filter

        print(f"--- Rendering '{templates_name}' templates for theme '{theme_name}'... ---")
        for template_name, paths in templates_data.items():
            src_path = paths.get("src")
            out_path = paths.get("out")

            if not src_path or not out_path:
                print(f"Skipping template '{template_name}' due to missing 'src' or 'out' path.")
                continue

            # Ensure the output directory exists
            out_path = Path(out_path)
            if not out_path.parent.is_dir():
                print(
                    f"Skipping template '{template_name}' output directory '{out_path.parent.resolve()}' does not exist."
                )
                continue

            try:
                # Load and render the template
                template = env.get_template(src_path)
                rendered_output = template.render(**theme_data)

                # Write the rendered output to the specified file
                with open(out_path, "w") as out_file:
                    out_file.write(rendered_output)

                print(f"Successfully rendered '{src_path}' to '{out_path}'")

            except Exception as e:
                print(f"Error rendering template '{src_path}': {e}")

        print("--- Done. ---")

    except FileNotFoundError:
        print(f"Error: The file '{theme_file_path}' was not found.")
    except json.JSONDecodeError:
        print(f"Error: The file '{theme_file_path}' is not a valid JSON file.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")


if __name__ == "__main__":
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Render templates using a specified theme.")
    parser.add_argument("--theme", "-t", default="catppuccin", help="The name of the theme json file to use.")
    parser.add_argument("--templates", "-temp", default="testing", help="The name of the theme json file to use.")
    args = parser.parse_args()

    # Run the main function with the specified theme
    render_templates_from_theme(args.theme, args.templates)
