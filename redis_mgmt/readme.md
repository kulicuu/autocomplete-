#### Redis management


We may be blocking running long computations on Lua scripts -- these would be implemeting data-structure construction algorithms to build data-structures such as Burkhard-Keller trees, from dictionaries of words.

So, we would need multiple Redis servers for the system. So here we set up the configuration files for these.  In the beginning would just be specifying different ports, but eventually might have more elaborate configuration schemes.
