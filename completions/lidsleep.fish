complete -c lidsleep -f
complete -c lidsleep -n __fish_use_subcommand -a on -d 'closing the lid suspends'
complete -c lidsleep -n __fish_use_subcommand -a off -d 'closing the lid does nothing'
complete -c lidsleep -n __fish_use_subcommand -a toggle -d 'switch between on and off'
complete -c lidsleep -n __fish_use_subcommand -a status -d 'show the current setting'
complete -c lidsleep -n __fish_use_subcommand -a reset -d 'turn lid sleep back on and remove the saved setting'
complete -c lidsleep -n __fish_use_subcommand -a help -d 'show help'
complete -c lidsleep -n __fish_use_subcommand -a version -d 'show the version'
complete -c lidsleep -n '__fish_seen_subcommand_from on off toggle' -s p -l permanent -d 'keep the change after logout and reboot'
