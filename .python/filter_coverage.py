import json
import sys

def main():
    if len(sys.argv) < 4:
        print("Usage: python filter_coverage.py <exclusions>")
        sys.exit(1)

    with open("coverage.json") as f:
        coverage_data = json.load(f)

    excluded_files = sys.argv[1].split(",")
    excluded_targets = sys.argv[2].split(",")
    file_name = sys.argv[3]
    filtered_targets = []

    for target in coverage_data["targets"]:
        if any(t in target["name"] for t in excluded_targets):
            continue

        files_in_target = []
        for file in target["files"]:
            if any(pattern in file["name"] for pattern in excluded_files):
                continue
            files_in_target.append(file)

        if files_in_target:
            target["files"] = files_in_target
            filtered_targets.append(target)

    coveredLines = 0
    executableLines = 0

    for target in filtered_targets:
        for file in target["files"]:
            coveredLines += int(file["coveredLines"])
            executableLines += int(file["executableLines"])

    with open(file_name, "w") as f:
        f.write(f"{coveredLines / executableLines * 100}")


if __name__ == "__main__":
    main()