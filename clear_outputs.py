import os
import shutil

def find_output_folders(root_dir):
    """Finds all 'outputs' subdirectories within the given root directory."""
    output_folders = []
    for dirpath, dirnames, filenames in os.walk(root_dir):
        if 'outputs' in dirnames:
            output_path = os.path.join(dirpath, 'outputs')
            output_folders.append(output_path)
    return output_folders

def clear_folder(folder_path):
    """Deletes all files within a specified folder."""
    if not os.path.isdir(folder_path):
        print(f"Error: {folder_path} is not a valid directory.")
        return False

    print(f"Clearing files in: {folder_path}")
    files_deleted = 0
    for item in os.listdir(folder_path):
        item_path = os.path.join(folder_path, item)
        if os.path.isfile(item_path):
            try:
                os.remove(item_path)
                print(f"  Deleted: {item}")
                files_deleted += 1
            except OSError as e:
                print(f"  Error deleting {item}: {e}")
    print(f"Finished clearing {folder_path}. {files_deleted} files deleted.")
    return True

def main():
    # Assume the script is run from the project root or adjust accordingly
    project_root = os.getcwd()
    print(f"Searching for output folders in: {project_root}")

    output_folders = find_output_folders(project_root)

    if not output_folders:
        print("No 'outputs' folders found to clear.")
        return

    print("\nFound the following 'outputs' folders:")
    for i, folder in enumerate(output_folders):
        print(f"{i+1}. {folder}")

    while True:
        choice = input("\nEnter the numbers of the folders to clear (e.g., '1 3'), 'all' to clear all, or 'q' to quit: ").strip().lower()

        if choice == 'q':
            print("Exiting without clearing any folders.")
            return
        elif choice == 'all':
            folders_to_clear = output_folders
            break
        else:
            try:
                selected_indices = [int(x) - 1 for x in choice.split()]
                folders_to_clear = []
                valid_selection = True
                for index in selected_indices:
                    if 0 <= index < len(output_folders):
                        folders_to_clear.append(output_folders[index])
                    else:
                        print(f"Invalid number: {index + 1}. Please enter valid numbers.")
                        valid_selection = False
                        break
                if valid_selection and folders_to_clear:
                    break
                elif not valid_selection:
                    continue
            except ValueError:
                print("Invalid input. Please enter numbers, 'all', or 'q'.")

    if folders_to_clear:
        print("\nFolders selected for clearing:")
        for folder in folders_to_clear:
            print(f"- {folder}")

        confirm = input("Are you sure you want to delete all files in these folders? (yes/no): ").strip().lower()
        if confirm == 'yes' or confirm == 'y':
            for folder in folders_to_clear:
                clear_folder(folder)
            print("\nOutput clearing process complete.")
        else:
            print("Operation cancelled.")

if __name__ == "__main__":
    main()
