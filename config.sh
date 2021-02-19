#!/bin/bash


Cyan='\033[0;36m'
Default='\033[0;m'

projectName=""
httpsRepo=""
homePage=""

getProjectName() {
    read -p "Enter Project Name: " projectName

    if test -z "$projectName"; then
        getProjectName
    fi
}

getProjectName
httpsRepo="http://10.250.6.6/wangyong_R21012/${projectName}.git"
homePage="http://10.250.6.6/wangyong_R21012/${projectName}"
echo -e "================================================\n"

mkdir -p "../${projectName}/${projectName}/${projectName}"

licenseFilePath="../${projectName}/FILE_LICENSE"
gitignoreFilePath="../${projectName}/.gitignore"
specFilePath="../${projectName}/${projectName}.podspec"
readmeFilePath="../${projectName}/readme.md"
updatePodPath="../${projectName}/update_pod.sh"
podfilePath="../${projectName}/Podfile"

echo "copy to $licenseFilePath"
cp -f ./templates/FILE_LICENSE "$licenseFilePath"
echo "copy to $gitignoreFilePath"
cp -f ./templates/gitignore    "$gitignoreFilePath"
echo "copy to $specFilePath"
cp -f ./templates/pod.podspec  "$specFilePath"
echo "copy to $readmeFilePath"
cp -f ./templates/readme.md    "$readmeFilePath"
echo "copy to $updatePodPath"
cp -f ./templates/update_pod.sh    "$updatePodPath"
echo "copy to $podfilePath"
cp -f ./templates/Podfile      "$podfilePath"

echo "editing..."
sed -i "" "s%__ProjectName__%${projectName}%g" "$gitignoreFilePath"
sed -i "" "s%__ProjectName__%${projectName}%g" "$readmeFilePath"
sed -i "" "s%__ProjectName__%${projectName}%g" "$updatePodPath"
sed -i "" "s%__ProjectName__%${projectName}%g" "$podfilePath"

sed -i "" "s%__ProjectName__%${projectName}%g" "$specFilePath"
sed -i "" "s%__HomePage__%${homePage}%g"      "$specFilePath"
sed -i "" "s%__HTTPSRepo__%${httpsRepo}%g"    "$specFilePath"
echo "edit finished"

echo "cleaning..."
cd ../$projectName
git init
git remote add origin $httpsRepo  &> /dev/null
git rm -rf --cached ./Pods/     &> /dev/null
git rm --cached Podfile.lock    &> /dev/null
git rm --cached .DS_Store       &> /dev/null
git rm -rf --cached $projectName.xcworkspace/           &> /dev/null
git rm -rf --cached $projectName.xcodeproj/xcuserdata/`whoami`.xcuserdatad/xcschemes/$projectName.xcscheme &> /dev/null
git rm -rf --cached $projectName.xcodeproj/project.xcworkspace/xcuserdata/ &> /dev/null
git add . &> /dev/null
git commit -m "first commit" &> /dev/null
git push -u origin master &> /dev/null
cd /Users/wangyong/Downloads/Autel/AutelPodTest2
echo "clean finished"
say "finished"
echo "finished"
