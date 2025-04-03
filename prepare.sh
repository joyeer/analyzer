
#!/bin/bash
# Set the JAR name
prepare_testdata_for_jdk() {
    version=$1

    export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
    export JAVA_VERSION=$version
    pushd ./Tests/JavaTests/Resources > /dev/null
    rm -rf ./target
    mvn -version
    mvn clean
    mvn package

    outputfolder=./output/$version
    mkdir -p $outputfolder

    mv ./target/*.jar $outputfolder

    # Loop through the classes (everything ending in .class)
    for class in $(jar -tf $outputfolder/testdata-1.0-SNAPSHOT.jar | grep '.class'); do
        # Replace /'s with .'s
        class=${class//\//.};
        tclass=${class//$/_};

        javap -classpath $outputfolder/testdata-1.0-SNAPSHOT.jar -c -private ${class//.class/} > $outputfolder/${tclass//.class/}.txt
    done

    popd > /dev/null
}


rm -rf ./Tests/JavaTests/Resources/output
rm -rf ./Tests/JavaTests/Resources/target

# compile to jdk 16
prepare_testdata_for_jdk 16
# compile to jdk 11
prepare_testdata_for_jdk 11
# # compile to jdk 8
prepare_testdata_for_jdk 1.8
