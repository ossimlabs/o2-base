properties([
    parameters ([
        string(name: 'BUILD_NODE', defaultValue: 'omar-build', description: 'The build node to run on'),
        booleanParam(name: 'CLEAN_WORKSPACE', defaultValue: true, description: 'Clean the workspace at the end of the run')
    ]),
    pipelineTriggers([
            [$class: "GitHubPushTrigger"]
    ]),
    [$class: 'GithubProjectProperty', displayName: '', projectUrlStr: 'https://github.com/ossimlabs/omar-base'],
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '3', daysToKeepStr: '', numToKeepStr: '20')),
    disableConcurrentBuilds()
])

node("${BUILD_NODE}"){
    try{
        stage("Checkout branch $BRANCH_NAME")
        {
            checkout(scm)
        }

        stage("Pull Artifacts")
        {
            withCredentials([string(credentialsId: 'o2-artifact-project', variable: 'o2ArtifactProject')]) {
                step ([$class: "CopyArtifact",
                    projectName: o2ArtifactProject,
                    filter: "common-variables.groovy",
                    flatten: true])

                step ([$class: "CopyArtifact",
                    projectName: o2ArtifactProject,
                    filter: "yum.repos.d/"])

                step ([$class: "CopyArtifact",
                    projectName: o2ArtifactProject,
                    filter: "goofys",
                    flatten: true])

                step ([$class: "CopyArtifact",
                    projectName: o2ArtifactProject,
                    filter: "run.sh"])

            }

            load "common-variables.groovy"

        }

        stage ("Publish Docker App")
        {
            withCredentials([[$class: 'UsernamePasswordMultiBinding',
                            credentialsId: 'dockerCredentials',
                            usernameVariable: 'DOCKER_REGISTRY_USERNAME',
                            passwordVariable: 'DOCKER_REGISTRY_PASSWORD']])
            {
                sh """
                gradle pushDockerImage \
                    -PossimMavenProxy=${MAVEN_DOWNLOAD_URL}
                """
            }
        }

        stage ("Publish Latest Tagged Docker App")
        {
            withCredentials([[$class: 'UsernamePasswordMultiBinding',
                            credentialsId: 'dockerCredentials',
                            usernameVariable: 'DOCKER_REGISTRY_USERNAME',
                            passwordVariable: 'DOCKER_REGISTRY_PASSWORD']])
            {
                // Tag to latest/release and push that too, to ensure the new changes get used by dependant apps
                if ("$BRANCH_NAME" == "dev") {
                    sh """
                        gradle tagDockerImage pushDockerImage \
                         -PdockerImageTag=latest \
                         -PossimMavenProxy=${MAVEN_DOWNLOAD_URL}
                    """
                } else if ("$BRANCH_NAME" == "master") {
                    sh """
                        gradle tagDockerImage pushDockerImage \
                         -PdockerImageTag=release \
                         -PossimMavenProxy=${MAVEN_DOWNLOAD_URL}
                    """
                }
            }
        }

    } finally {

        stage("Clean Workspace")
        {
            if ("${CLEAN_WORKSPACE}" == "true")
                step([$class: 'WsCleanup'])
        }
    }
}
