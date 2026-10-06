# OAM Traits > Open Application Model

## An open model for defining cloud native apps.

"Focused on application rather than container or orchestrator, Open Application Model [OAM] brings modular, extensible, and portable design for modeling application deployment with higher level yet consistent API.

This is the key to enable simple yet robust application delivery across hybrid environments including Kubernetes, cloud, or even IoT devices."

-- [OAM website](https://oam.dev/)

# Kubevela

Kubevela (https://kubevela.io/docs/) is the platform to deploy OAM applications to kubernetes,
making shipping applications enjoyable.

Read more about at [Kubevela](https://kubevela.io/docs/).

A Kubevela application is an abstraction to model your application deployment with everything
that is needed in a simple yaml file without having to worry about kubernetes at all.

An application may have several components with traits modifying the behavior of them and additionally policies and workflows.

## How to start writing your application

Once you have an understanding of the main components of a vela application you should identify the parts of your application
and translate them into traits or components.

The best guide for traits and components is to run the ```vela show``` command, but it requires to be connected to your
cluster and have the kubevela client installed. Otherwise, you check kubevela docs, this repo and another existing applications

Write a first version of you application and check locally before deploying it with devhub to ensure the syntax is correct.
The best way to do this is running the command ```vela dry-run -f <your-app>.yaml``` and check slightly the output (you don't need
to be a k8s expert) but you can fix a potential syntax or unexpected behaviour before deploying.

To test your application you will need to have access to your dev cluster with teleport as the vela client will use
the kubevela installation that is provided with every cluster.

## Developing Custom Traits/Components

One powerful ability of Kubevela is that you can develop your custom components/traits according to your needs. Kubevela use CUE language
[cue language](https://cuelang.org/docs/) as its core engine and you can

To learn more about developing custom traits, have a look at the src directory of the repo and the test folder
Additionally the following resources are recommended:
* [CUE in kubevela](https://kubevela.io/docs/platform-engineers/cue/basic)
* [Customizing traits](https://kubevela.io/docs/platform-engineers/traits/customize-trait#using-cue-as-trait-schematic).
* [CUE patterns](https://cuetorials.com/patterns/fields/)

This repo already provides custom traits/components to facilitate the definition of your OAM application.
