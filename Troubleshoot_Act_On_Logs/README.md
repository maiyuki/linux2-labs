# Lab - Troubleshoot and read information from logs

## Description

We'll walk through a few common scenarios you might encounter in your future work places.
Scenario 1 - Static log analysis
Scenario 2 - Scripted log monitoring
Scenario 3 - Extrapolate information from a completely unknown application

## Prerequisites

No prerequisites, only critical thinking and all your general/specific Linux experience

## Objectives

Draw conclusion from completely static log analysis, no application, no testing, nothing active.
Purely static.

## Software

Whatever tools will help you work with text files most efficiently, my favorites include:
  - awk
  - less
  - grep
  - vim
  - emac.... HAH, Just kidding.

## Vagrant

Creates a VM

`vm01 172.22.100.10`

# Scenario 1 - Static Log Analysis

Scenario 1 - Static Log Analysis. Starting simple!
Imagine, you've recently started working at Evil Corp.

Boss comes to you, asking you to take a look at the "vm01", he says there's some webserver logs an application stores there.
He gives you the location: `/mnt/logs/access-vm02-2021-01-03.log.gz`

You asked for more details however, he couldn't provide any, it's a super old server, no one really knows how those logs show up there.

The only thing he said, users using the application from where these logs come from are having problems viewing the page, in their words: "After logging in, I can't see anything. All a blank screen, no matter how many times I refresh or which browser I'm using. Fix it NAO!"

Your tasks:
 - Make an educated guess what application writes the log file
 - Make an educated guess what server writes the log files
 - Find the lines that indicate any problems
 - Narrow down if it's a global issue or user/application specific
 - Possible suggestions to remediate the problem

 NOTE! : Keep in mind, all of this is static analysis, so all you need is the log file and you text manipulation tools and a bit of google.

# Scenario 2 - Scripted Log Monitoring

Scenario 2 - Scripted log monitoring

Great, you're boss is very impressed with how you handled the Static Log Analysis, he gives you something more challenging.
He again asks you to take a look at "vm01", apparently that server gets a lot of authentication requests... You know everyone's afraid of the "scary American hackers".
He asks if there's something you can do about it, possibly automating writing a simple report of each IP and how many requests it made and based on that information he'll make the decision whom to block, apparently a lot of users are making incorrect password attempts and he doesn't want false positive lock outs!
He gives you the location of the SSH log files and asks to write the automation in Bash (but anything else is acceptable too)

Log location: `/mnt/ssh/ssh-2021-01-04.log.gz`

Your tasks:
 - Create a script that analysis the example SSH log and provides the following statistics:
   - All unique IPs with number or failed login attempts
   - List of IPs that crossed a preset threshold (must be easily configurable). For our purposes let's set the threshold to 15 failed attempts
   - Save the output of the script to a separate folder in `/mnt/ssh/`, in the following format:` ssh-attempt-YYYY-MM-DD.txt.gz`
   - Output of the script *MUST* be gzipped

NOTE! : If you want to add an emailing function to the script or anything else additional, feel free! Let your creativity shine :)

# Scenario 3 - Extrapolate information from a completely unknown application

Scenario 3 - In some cases the most fun, yet usually the most challenging scenario... Unknown application, log format.

You will come across unknown, legacy, super old or simply unmaintained/undocumented applications, with the expectation to fix them. So while in most cases that's very difficult to do only having log files, they still can contain a lot of useful information to help you discover problems and figure out how it works!

Your boss comes to you, with his final challenge. They have a black box application, no one has touched or worked with in 5 years. The developer who initially wrote it, is long gone and not even the source code is available anywhere! All you have a log file.
Yesterday it suddenly stopped working, how do they know, because the whole company depends on it, it seems. It's the backend authentication service that the email server uses, yikes! :)
You're tasked to figure out as much as you can about the application and why it no longer works, all from a log file.

Log location: `/mnt/auth/auth_2021-01-04.log.zip`

Your tasks: 
 - Figure out what the application is running on (language it's written in, framework used, version, etc.)
 - Figure out why the application is no longer working
 - Remediation plan: what is the problem, likely causes, and possible fixes

NOTE! : Again no active running application, completely log based. Here I'd recommend using a lot of Google, since the logs might be completely unknown, so google anything you don't know. 


## Answers / Guide

### Scenario 1

 - If we take a look at the file name, we can see it has "access" in the name. That usually indicates that a webserver is writing "access" logs to that file. It's a pretty weak assumption, however, we verify it after opening the files and inspecting the first few lines. We see URLs, IPs, HTTP codes, User-Agent Strings. Dead giveaway it's webserver logs, so application is most likely Nginx/Apache.
 - This is easy but a very rough estimate. We can see a hostname in the file name "vm02" since it doesn't match the host name of the box we are currently on, it's a relatively safe assumption to make that the logs come from "vm02"
 - We can grep for common error HTTP codes, pretty much anything in the 4xx and 5xx range. However since we might not know what we're dealing with, you might prefer to "grep-out" all of the successes to see what's left. Like: ```grep -v "200" logFile```
 - Once we have an idea of the problem, in our case it's that the IP  is getting a 401 when trying to POST to /users/login, we need to see if other IPs are having the same problem. You can grep for "/users/login" and see if there are any other offenders. If there are it indicates a bigger problem, for example the application is rejecting all logins (which might indicate a further issue, like it can't reach a database or an authentication backend). In our case, we see a few successes from different IPs to the same "/users/login" endpoint, so we can assume the scope is narrowed to the specific user.
 - Remediation: Given that only a single user is failing to enter the site and based on the logs he's getting 401 HTTP code on "/users/login", we can assume he's failing to login completely. Reasons behind it are most likely: the user is locked out, the password expired or he's supplying an incorrect password. Contact the application support team and ask to review the user and possibly reset his password.

### Scenario 2

I won't give you the full scripts, however I'll help with the most challenging part, getting occurences.
I'm a fan of one liners, feel free to move them to your actual nicely written scripts:
 - An example with AWK would look something like this:
```bash
zcat ssh-2021-01-04.log.gz | egrep "Invalid|Did not receive|Failed" | awk -F "from " '{print $2}' | awk '{print $1}' | awk '{ count [$0]++ } END { for(ind in count) { print ind,count[ind]  } }'
```
 - With uniq:
```bash
zcat ssh-2021-01-04.log.gz | egrep "Invalid|Did not receive|Failed" | awk -F "from " '{print $2}' | awk '{print $1}' | sort | uniq -c
```

### Scenario 3

 - Logs are from an application written in Java:
   - This comes mostly from experience, those "stacktraces" are very Java-esque, but a dead give away is that it's a Spring Boot application. And if we google Spring Boot, it'll come up as a Java-based framework. You can also see the version when it's starting up too.
 - If you take a look at the stack traces, regardless of how much you know or don't know Java (or any language for that matter), you can always find something familiar. In this scenario if you pay good attention, you'll find that that the application is failing to login to the database.
 - Now that we know it can't connect to the DB, remediation would be something like: Is the DB up and running, are the credentials correct? If both are yes:
   - Is the routing/networking in place? Can you ping the host?
   - Is it a firewall blocking you somewhere?
   - Were there any changes made recently to either the application or the DB or somewhere in between?
   - If all of the above are good, it can be more application specific:
     - Bad driver used inside the code.
     - Updates to the DB might cause it to be incompatible with the software if it's unmaintained.
     - Typos / Errors in the configuration file

With this little information, you can't make any definitive statements, however you've extrapolated a whole lot of information from so little. You went from knowing nothing, to having a plan in a short amount of time and that is KEY! You might not know Java, but you know logs and you know the basics and as long as you have a good mindset, you can usually figure out even the weirdest of applications and logs :)

--
