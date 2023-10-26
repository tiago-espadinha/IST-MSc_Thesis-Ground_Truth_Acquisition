import os
import shutil

def find_asset_folders(root_dir):
    """Finds all 'assets' subdirectories within the given root directory."""
    asset_folders = []
    for dirpath, dirnames, filenames in os.walk(root_dir):
        # Exclude the 'shared-assets' directory itself from being considered an asset folder
        # and also exclude any 'assets' folder that might be *inside* 'shared-assets'
        if 'shared-assets' in dirpath.split(os.sep):
            continue

        if 'assets' in dirnames:
            asset_path = os.path.join(dirpath, 'assets')
            asset_folders.append(asset_path)
    return asset_folders

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
    print(f"Searching for asset folders in: {project_root}")

    asset_folders = find_asset_folders(project_root)

    if not asset_folders:
        print("No 'assets' folders found to clear (excluding 'shared-assets').")
        return

    print("\nFound the following 'assets' folders:")
    for i, folder in enumerate(asset_folders):
        print(f"{i+1}. {folder}")

    while True:
        choice = input("\nEnter the numbers of the folders to clear (e.g., '1 3'), 'all' to clear all, or 'q' to quit: ").strip().lower()

        if choice == 'q':
            print("Exiting without clearing any folders.")
            return
        elif choice == 'all':
            folders_to_clear = asset_folders
            break
        else:
            try:
                selected_indices = [int(x) - 1 for x in choice.split()]
                folders_to_clear = []
                valid_selection = True
                for index in selected_indices:
                    if 0 <= index < len(asset_folders):
                        folders_to_clear.append(asset_folders[index])
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
            print("\nAsset clearing process complete.")
        else:
            print("Operation cancelled.")

if __name__ == "__main__":
    main()
