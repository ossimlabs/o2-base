properties([
    parameters ([
        string(name: 'BUILD_NODE', defaultValue: 'omar-build', description: 'The build node to run on'),
        booleanParam(name: 'CLEAN_WORKSPACE', defaultValue: true, description: 'Clean the workspace at the end of the run')
    ]),
    pipelineTriggers([
            [$class: "GitHubPushTrigger"]
    ]),
    [$class: 'GithubProjectProperty', displayName: '', projectUrlStr: 'https://github.com/ossimlabs/omar-base'],
    disableConcurrentBuilds()
])

node("${BUILD_NODE}"){

    stage("Checkout branch $BRANCH_NAME")
    {
        checkout(scm)
    }

    stage("Load Variables")
    {
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
            // Run all tasks on the app. This includes pushing to OpenShift and S3.
            sh """
            gradle pushDockerImage \
                -PossimMavenProxy=${OSSIM_MAVEN_PROXY}
            """
        }
    }
        
    stage("Clean Workspace")
    {
        if ("${CLEAN_WORKSPACE}" == "true")
            step([$class: 'WsCleanup'])
    }
}
