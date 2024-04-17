major=$(grep FROM Dockerfile | awk -F':' '{print $2}' | awk -F'-' '{print $1}');let minor=$(git tag | grep -E $major-[0-9]+ | cut -d- -f2 | sort -n | tail -n 1 )+1; echo $major-$minor
