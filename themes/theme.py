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
import sys
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

VERBOSE = False

config_path = Path.home() / Path(".config/themes")
themes_path = config_path / Path("themes")
templates_path = config_path / Path("templates")


def set_verbose(verbose: bool):
    global VERBOSE
    VERBOSE = verbose


def strip_filter(text):
    return text.lstrip("#")


def vprint(message):
    if VERBOSE:
        print(message)


def list_themes(config_name):
    """
    Lists all the themes in themes directory.
    """
    config_file_path = config_path / f"{config_name}.json"

    if not config_file_path.is_file():
        vprint(f"Error: The templetes configuration file '{config_file_path}' was not found.")
        return

    if not themes_path.is_dir():
        vprint(f"Error: The path '{themes_path}' is not a valid directory.")
        return

    try:
        # Use glob to find all files with a .json extension
        json_files = list(themes_path.glob("*.json"))
        if json_files:
            for file in json_files:
                print(f"{file.stem}")

    except OSError as e:
        print(f"An error occurred while accessing the path: {e}")


def apply_theme(theme_name, config_name):
    """
    Renders Jinja2 templates from a specified theme directory.

    Args:
        theme_name (str): The name of the theme json file without extension.
        templates_name (str): The name the templates json file without extension.
    """
    theme_file_path = themes_path / f"{theme_name}.json"
    config_file_path = config_path / f"{config_name}.json"

    # Check files exist
    if not theme_file_path.is_file():
        vprint(f"Error: The theme configuration file '{theme_file_path}' was not found.")
        return

    if not config_file_path.is_file():
        vprint(f"Error: The templetes configuration file '{config_file_path}' was not found.")
        return

    try:
        # Load the configuration json files
        with open(theme_file_path, "r") as f:
            theme_data = json.load(f)

        with open(config_file_path, "r") as f:
            config_data = json.load(f)
            current_theme = config_data.get("current_theme")
            templates_data = config_data.get("templates")
            vprint(f"Current theme: {current_theme}")

        if not templates_data:
            vprint("No templates found in the configuration file.")
            return

        # Set up the Jinja2 environment to load templates from the specified directory
        env = Environment(loader=FileSystemLoader(templates_path), trim_blocks=True, lstrip_blocks=True)

        # Register custom filters
        env.filters["strip"] = strip_filter

        vprint(f"Rendering '{config_name}' templates for theme '{theme_name}'...")
        for template_name, paths in templates_data.items():
            src_path = paths.get("src")
            out_path = paths.get("out")

            if not src_path or not out_path:
                vprint(f"Skipping template '{template_name}' due to missing 'src' or 'out' path.")
                continue

            # Ensure the output directory exists
            out_path = Path(out_path).expanduser()
            if not out_path.parent.is_dir():
                vprint(
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

                vprint(f"Successfully rendered '{src_path}' to '{out_path}'")

            except Exception as e:
                vprint(f"Error rendering template '{src_path}': {e}")

        # Write new current theme
        config_data["current_theme"] = theme_name
        with open(config_file_path, "w") as f:
            json.dump(config_data, f, indent=4)
        vprint(f"New theme: {theme_name}")

    except FileNotFoundError:
        print(f"Error: The file '{theme_file_path}' was not found.")
    except json.JSONDecodeError:
        print(f"Error: The file '{theme_file_path}' is not a valid JSON file.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")


def main():
    parser = argparse.ArgumentParser(description="A command-line tool for managing themes.")
    subparsers = parser.add_subparsers(dest="command", help="Available commands")

    list_parser = subparsers.add_parser("list", help="List all available themes.")
    list_parser.add_argument(
        "-c", "--config", dest="config_name", default="testing", help="Specify a config json to use with the theme."
    )
    list_parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose output.")

    theme_parser = subparsers.add_parser("theme", help="Apply a theme with optional settings.")
    theme_parser.add_argument("theme_name", help="The name of the theme to apply.")
    theme_parser.add_argument(
        "-c", "--config", dest="config_name", default="testing", help="Specify a config json to use with the theme."
    )
    theme_parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose output.")

    # No Args
    if len(sys.argv) == 1:
        parser.print_help(sys.stderr)
        sys.exit(1)

    # Handle Args
    args = parser.parse_args()
    set_verbose(args.verbose)
    if args.command == "list":
        list_themes(args.config_name)
    elif args.command == "theme":
        apply_theme(args.theme_name, args.config_name)
    else:
        parser.print_help(sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
