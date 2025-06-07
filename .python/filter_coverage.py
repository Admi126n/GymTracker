import json
import sys

def write_summary(file_name, excluded_files, included_files, coveredLines, executableLines):
    with open(file_name, "w") as f:
        f.write("Excluded files:\n")
        f.write("\n".join(sorted(excluded_files)))
        
        f.write("\n\nIncluded files:\n")
        f.write("\n".join(sorted(included_files)))

        f.write(f"\n\nCode coverage summary: {coveredLines / executableLines * 100:.2f}%")


def main():
    if len(sys.argv) < 5:
        print("Usage: python filter_coverage.py <exclusions>")
        sys.exit(1)

    with open("coverage.json") as f:
        coverage_data = json.load(f)

    exclusion_suffixes = sys.argv[1].split(",")
    excluded_targets = sys.argv[2].split(",")
    coverage_percentage_file = sys.argv[3]
    coverage_summary_file = sys.argv[4]
    
    included_targets = []
    excluded_files = []
    included_files = []

    for target in coverage_data["targets"]:
        if any(excluded in target["name"] for excluded in excluded_targets):
            continue

        files_in_target = []
        for file in target["files"]:
            if any(file["name"].endswith(f"{suffix}.swift") for suffix in exclusion_suffixes):
                excluded_files.append(file["name"])
                continue

            files_in_target.append(file)

        if files_in_target:
            target["files"] = files_in_target
            included_targets.append(target)

    coveredLines = 0
    executableLines = 0

    for target in included_targets:
        for file in target["files"]:
            covered = int(file["coveredLines"])
            executable = int(file["executableLines"])

            coveredLines += covered
            executableLines += executable

            included_files.append(f"{file["name"]}: {covered}/{executable} ({covered / executable * 100:.2f}%)")

    with open(coverage_percentage_file, "w") as f:
        f.write(f"{coveredLines / executableLines * 100:.2f}")

    write_summary(coverage_summary_file, excluded_files, included_files, coveredLines, executableLines)
    

if __name__ == "__main__":
    main()