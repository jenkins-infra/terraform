#!/usr/bin/env groovy

properties([
    buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5')),
    pipelineTriggers([cron('@weekly')]),
])

node('docker') {
    /* Make sure we're starting with a pristine workspace */
    deleteDir()

    String imageName = 'jenkinsciinfra/terraform'
    String commitHash
    def container = null

    stage('Checkout') {
        checkout scm
        sh 'git remote add upstream https://github.com/hashicorp/terraform.git && git fetch --all'
        commitHash = sh(returnStdout: true, script: 'git show-ref --abbrev upstream/master | awk "{print $1}"')
        /* Grab the latest from upstream and merge it before we attempt to
         * build anything
         */
        sh 'git merge --commit  upstream/master'
    }

    stage('Build') {
        container = docker.build("${imageName}:${commitHash}", '--no-cache --rm .')
    }

    stage('Publish') {
        if (container) {
            container.push()
            /* Might as well make the 'latest' tag */
            container.push('latest')
        }
    }
}
