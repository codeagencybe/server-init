# commands

This method will reboot the system as if cloud-init never ran. This command does not remove all cloud-init artefacts from previous runs of cloud-init, but it will clean enough artefacts to allow cloud-init to think that it hasn’t run yet. It will then re-run after a reboot.

```bash
cloud-init clean --logs --reboot
```

https://cloudinit.readthedocs.io/en/latest/howto/rerun_cloud_init.html
