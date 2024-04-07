def registry = 'https://valaxy02.jfrog.io'
def imageName = 'valaxy02.jfrog.io/valaxy-docker/ttrend'
def version = '2.0.3'

node {
    stage('build') {
        echo "------------ build started ---------"
        sh 'mvn clean deploy -Dmaven.test.skip=true'
        echo "------------ build completed ---------"
    }

    stage('SonarQube analysis') {
        def scannerHome = tool 'sonar-scanner';
        withSonarQubeEnv('sonarqube-server') {
            sh "${scannerHome}/bin/sonar-scanner"
        }
    }

    stage("Jar Publish") {
        echo '<--------------- Jar Publish Started --------------->'
        def server = Artifactory.newServer url: registry + "/artifactory", credentialsId: "jfrog-access"
        def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
        def uploadSpec = """{
            "files": [
                {
                    "pattern": "jarstaging/(*)",
                    "target": "twittertrend-libs-release-local/{1}",
                    "flat": "false",
                    "props": "${properties}",
                    "exclusions": ["*.sha1", "*.md5"]
                }
            ]
        }"""
        def buildInfo = server.upload(uploadSpec)
        buildInfo.env.collect()
        server.publishBuildInfo(buildInfo)
        echo '<--------------- Jar Publish Ended --------------->'
    }

    stage("Docker Build") {
        echo '<--------------- Docker Build Started --------------->'
        def app = docker.build(imageName + ":" + version)
        echo '<--------------- Docker Build Ends --------------->'
    }

    stage("Docker Publish") {
        echo '<--------------- Docker Publish Started --------------->'
        docker.withRegistry(registry, 'jfrog-access') {
            app.push()
        }
        echo '<--------------- Docker Publish Ended --------------->'
    }
}
