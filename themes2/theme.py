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
import os
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

themes_path = Path.home() / Path(".config/themes2")
templates_path = themes_path / Path("templates")


def strip_filter(text):
    return text.lstrip("#")


def render_templates_from_theme(theme_name):
    """
    Renders Jinja2 templates from a specified theme directory.

    Args:
        theme_name (str): The name of the theme directory.
    """
    theme_path = themes_path / f"{theme_name}.json"

    # Check if the theme configuration file exists
    if not theme_path.is_file():
        print(f"Error: The theme configuration file '{theme_path}' was not found.")
        return

    try:
        # Load the configuration from the theme.json file
        with open(theme_path, "r") as f:
            config_data = json.load(f)

        # Get the template data and the dictionary of templates to process
        template_data = config_data.get("theme", {})
        templates_map = config_data.get("templates", {})

        if not templates_map:
            print("No templates found in the configuration file.")
            return

        # Set up the Jinja2 environment to load templates from the specified directory
        env = Environment(loader=FileSystemLoader(templates_path), trim_blocks=True, lstrip_blocks=True)

        # Register custom filters
        env.filters["strip"] = strip_filter

        print(f"--- Rendering templates for theme '{theme_name}'... ---")
        for template_name, paths in templates_map.items():
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
                rendered_output = template.render(**template_data)

                # Write the rendered output to the specified file
                with open(out_path, "w") as out_file:
                    out_file.write(rendered_output)

                print(f"Successfully rendered '{src_path}' to '{out_path}'")

            except Exception as e:
                print(f"Error rendering template '{src_path}': {e}")

        print("\n--- Done. ---")

    except FileNotFoundError:
        print(f"Error: The file '{theme_path}' was not found.")
    except json.JSONDecodeError:
        print(f"Error: The file '{theme_path}' is not a valid JSON file.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")


if __name__ == "__main__":
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Render templates using a specified theme.")
    parser.add_argument("--theme", "-t", default="my_theme", help="The name of the theme file to use.")
    args = parser.parse_args()

    # Run the main function with the specified theme
    render_templates_from_theme(args.theme)
