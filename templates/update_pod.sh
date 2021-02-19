
#查找pod模块名称
curPath=$(pwd)
sdkName=$(find . -name "*.podspec" -maxdepth 1)
sdkName="${sdkName#./}"
sdkName="${sdkName%.podspec}"
echo "识别:sdkName=${sdkName}"

#查找spec库名称
cd ~/.cocoapods/repos
specPath="$(pwd)"

#开始打标签
cd "${curPath}"
# 当前版本号
OID_VERSION=''
NEW_VERSION=''

while read line
do
    # echo $line
    if [[ $line == s.version* ]]; then
        # echo $line
        RE="\'([^\']*)\'"
        RE_DOUBLE="\"([^\"]*)\""
        if [[ $line =~ $RE || $line =~ $RE_DOUBLE ]]; then
            OID_VERSION=${BASH_REMATCH[1]}
        fi
        break
    fi
done < ${curPath}/${sdkName}.podspec


function increment_version ()
{
  declare -a part=( ${1//\./ } )
  declare    new
  declare -i carry=1

  for (( CNTR=${#part[@]}-1; CNTR>=0; CNTR-=1 )); do
    len=${#part[CNTR]}
    new=$((part[CNTR]+carry))
    [ ${#new} -gt $len ] && carry=1 || carry=0
    [ $CNTR -gt 0 ] && part[CNTR]=${new: -len} || part[CNTR]=${new}
  done
  new="${part[*]}"
  NEW_VERSION=${new// /.}
}

increment_version $OID_VERSION
echo "当前podspec版本号 $OID_VERSION"
echo "自增版本号 $NEW_VERSION"

echo "打标签:{$sdkName}:开始"
sed -i "" "s/s.version      = .*/s.version      = '$NEW_VERSION'/g" $sdkName.podspec

git add $sdkName.podspec
#git add .
git commit -m "打标签:${NEW_VERSION}"
git push #origin


git tag $NEW_VERSION

git push --tags #origin

echo "打标签{$sdkName}:完成"

#开始处理spec库
echo "处理spec库:开始"
pod spec lint $sdkName.podspec  --allow-warnings
echo "spec push..."
pod repo push BaseSpecs $sdkName.podspec  --allow-warnings
echo "处理spec库:完成"



