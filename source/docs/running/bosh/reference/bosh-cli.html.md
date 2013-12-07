---
title: BOSH Command Line Interface
---

Use the BOSH command line interface to interact with the BOSH director and perform actions on the cloud.  For the most recent documentation on its functions, install BOSH and simply type `bosh`.  Usage:
<pre class="terminal">
    Usage: bosh [&lt;options&gt;] <command> [&lt;args&gt;]
        -c, --config FILE                Override configuration file. Also can be overridden by BOSH\_CONFIG environment variable. Defaults to $HOME/.bosh_config. Override precedence is command-line option, then environment variable, then home directory.
        -C, --cache-dir DIR              Override cache directory
            --[no-]color                 Toggle colorized output
        -v, --verbose                    Show additional output
        -q, --quiet                      Suppress all output
        -n, --non-interactive            Don't ask for user input
        -N, --no-track                   Return Task ID and don't track
        -P, --poll INTERVAL              Director task polling interval
        -t, --target URL                 Override target
        -u, --user USER                  Override username
        -p, --password PASSWORD          Override password
        -d, --deployment FILE            Override deployment
</pre>
Currently available bosh commands are:

~~~
 add blob <local_path> [<blob_dir>]
     Add a local file as BOSH blob

 alias <name> <command>
     Create an alias <name> for command <command>

 aliases
     Show the list of available command aliases

 blobs
     Print current blobs status

 cancel task <task_id>
     Cancel task once it reaches the next checkpoint

 cleanup
     Cleanup releases and stemcells

 cleanup ssh
     Cleanup SSH artifacts

 cloudcheck [<deployment_name>] [--auto] [--report]
     Cloud consistency check and interactive repair
     --auto   resolve problems automatically (not recommended for production)
     --report generate report only, don't attempt to resolve problems

 complete
     Command completion options

 create release [<manifest_file>] [--force] [--final] [--with-tarball]
                [--dry-run]
     Create release (assumes current directory to be a release repository)
     --force        bypass git dirty state check
     --final        create final release
     --with-tarball create release tarball
     --dry-run      stop before writing release manifest

 create user [<username>] [<password>]
     Create user

 delete deployment <name> [--force]
     Delete deployment
     --force ignore errors while deleting

 delete release <name> [<version>] [--force]
     Delete release (or a particular release version)
     --force ignore errors during deletion

 delete snapshot <snapshot_cid>
     Deletes a snapshot

 delete snapshots
     Deletes all snapshots of a deployment

 delete stemcell <name> <version> [--force]
     Delete stemcell
     --force ignore errors while deleting the stemcell

 delete user [<username>]
     Deletes the user from the director

 deploy [--recreate]
     Deploy according to the currently selected deployment manifest
     --recreate recreate all VMs in deployment

 deployment [<filename>]
     Get/set current deployment

 deployments
     Show the list of available deployments

 diff <template>
     Diffs your current BOSH deployment configuration against the specified BOSH deployment configuration template so
     that you can keep your deployment configuration file up to date. A dev template can be found in deployments repos.

 download manifest <deployment_name> [<save_as>]
     Download deployment manifest locally

 download public stemcell <stemcell_name>
     Downloads a stemcell from the public blobstore

 edit deployment
     Edit current deployment manifest

 generate job <name>
     Generate job template

 generate package <name>
     Generate package template

 get property <name>
     Get deployment property

 help [--all]
     Show help message
     --all Show help for all BOSH commands

 init release [<base>] [--git]
     Initialize release directory
     --git initialize git repository

 login [<username>] [<password>]
     Log in to currently targeted director. The username and password can also be set in the BOSH_USER and BOSH_PASSWORD
     environment variables.

 logout
     Forget saved credentials for targeted director

 logs <job> <index> [--agent] [--job] [--only filter1,filter2,...]
      [--all] [--dir destination_directory]
     Fetch job or agent logs from a BOSH-managed VM
     --agent                     fetch agent logs
     --job                       fetch job logs
     --only filter1,filter2,...  only fetch logs that satisfy given filters (defined in job spec)
     --all                       fetch all files in the job or agent log directory
     --dir destination_directory download directory

 properties [--terse]
     List deployment properties
     --terse easy to parse output

 public stemcells [--full] [--tags tag1,tag2...] [--all]
     Show the list of publicly available stemcells for download.
     --full              show the full download url
     --tags tag1,tag2... filter by tag
     --all               show all stemcells

 recreate <job> [<index>] [--force]
     Recreate job/instance (hard stop + start)
     --force Proceed even when there are other manifest changes

 releases
     Show the list of available releases

 rename job <old_name> <new_name> [--force]
     Renames a job. NOTE, your deployment manifest must also be updated to reflect the new job name.
     --force Ignore errors

 reset release
     Reset dev release

 restart <job> [<index>] [--force]
     Restart job/instance (soft stop + start)
     --force Proceed even when there are other manifest changes

 scp [--download] [--upload] [--public_key FILE] [--gateway_host HOST]
     [--gateway_user USER]
     upload/download the source file to the given job. Note: for download /path/to/destination is a directory
     --download          Download file
     --upload            Upload file
     --public_key FILE   Public key
     --gateway_host HOST Gateway host
     --gateway_user USER Gateway user

 set property <name> <value>
     Set deployment property

 snapshots [<job>] [<index>]
     List all snapshots

 ssh [--public_key FILE] [--gateway_host HOST] [--gateway_user USER]
     [--default_password PASSWORD]
     Execute command or start an interactive session
     --public_key FILE           Public key
     --gateway_host HOST         Gateway host
     --gateway_user USER         Gateway user
     --default_password PASSWORD Use default ssh password (NOT RECOMMENDED)

 start <job> [<index>] [--force]
     Start job/instance
     --force Proceed even when there are other manifest changes

 status
     Show current status (current target, user, deployment info etc)

 stemcells
     Show the list of available stemcells

 stop <job> [<index>] [--soft] [--hard] [--force]
     Stop job/instance
     --soft  Stop process only
     --hard  Power off VM
     --force Proceed even when there are other manifest changes

 sync blobs
     Sync blob with the blobstore

 take snapshot [<job>] [<index>]
     Takes a snapshot

 target [<director_url>] [<name>]
     Choose director to talk to (optionally creating an alias). If no arguments given, show currently targeted director

 targets
     Show the list of available targets

 task [<task_id>] [--no-cache] [--event] [--cpi] [--debug] [--result]
      [--raw] [--no-filter]
     Show task status and start tracking its output
     --no-cache  Don't cache output locally
     --event     Track event log
     --cpi       Track CPI log
     --debug     Track debug log
     --result    Track result log
     --raw       Show raw log
     --no-filter Include all task types (ssh, logs, vms, etc)

 tasks [--no-filter]
     Show running tasks
     --no-filter Include all task types (ssh, logs, vms, etc)

 tasks recent [<count>] [--no-filter]
     Show <number> recent tasks
     --no-filter Include all task types (ssh, logs, vms, etc)

 unset property <name>
     Unset deployment property

 upload blobs
     Upload new and updated blobs to the blobstore

 upload release [<release_file>] [--rebase]
     Upload release
     --rebase Rebases this release onto the latest version known by director (discards local job/package versions in
              favor of versions assigned by director)

 upload stemcell <tarball_path>
     Upload stemcell

 validate jobs
     Validates all jobs in the current release using current deployment manifest as the source of properties

 verify release <tarball_path>
     Verify release

 verify stemcell <tarball_path>
     Verify stemcell

 version
     Show version

 vms [<deployment_name>] [--details] [--vitals]
     List all VMs in a deployment
     --details Return detailed VM information
     --vitals  Return VM vitals information
~~~