#!/usr/bin/env python
# coding: utf-8

# In[10]:


f = open("log.lammps", "r")
for x in f:
  pass
assert x[:15] == "Total wall time"

