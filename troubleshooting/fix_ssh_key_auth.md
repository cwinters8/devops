## The Problem

Recently, I beat my head against a wall for hours because 2 out of 3 PostgreSQL nodes refused to connect via public keys, even though all permissions were verified and the keys were generated and propogated using the appropriate method. The working node and the non-working nodes appeared identical in configuration. The only user experiencing the issue was the postgres user.

## The Fix

I ran the following command on all three nodes (as root) to fix SELinux file contexts, as suggested [here](https://superuser.com/a/676225/756803)
```bash
restorecon -Rv ~postgres/.ssh
```
I got back the following output on nodes 2 and 3 (the ones that weren't working), and no output from the working node.
```bash
restorecon reset /var/lib/pgsql/.ssh context unconfined_u:object_r:postgresql_db_t:s0->unconfined_u:object_r:ssh_home_t:s0
restorecon reset /var/lib/pgsql/.ssh/id_rsa context unconfined_u:object_r:postgresql_db_t:s0->unconfined_u:object_r:ssh_home_t:s0
restorecon reset /var/lib/pgsql/.ssh/id_rsa.pub context unconfined_u:object_r:postgresql_db_t:s0->unconfined_u:object_r:ssh_home_t:s0
restorecon reset /var/lib/pgsql/.ssh/known_hosts context unconfined_u:object_r:postgresql_db_t:s0->unconfined_u:object_r:ssh_home_t:s0
restorecon reset /var/lib/pgsql/.ssh/authorized_keys context unconfined_u:object_r:postgresql_db_t:s0->unconfined_u:object_r:ssh_home_t:s0
```

Going back to the postgres user, I could successfully connect using my public keys!

```ShellSession
[postgres@cwinters3 ~]$ ssh cwinters5
Last login: Mon Jul 31 17:36:28 2017 from cwinters4.mylabserver.com
[postgres@cwinters5 ~]$ 
```
