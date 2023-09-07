# kubernetes-deployment
Tests for Kubernetes deployments using multiple namespaces/pods


# Substitutions

Substitutions are for where we want to add a dynamic entry in the yaml files. My testing is on 2 different setups and both are not compatible with each other and therefore substitutions make this easy. Also namespaces can be altered easily

## Adding substitutions

There are 3 places  to add substitions. 
1. defaults.txt. This is the defaults used that are common
2. .envconfig. A non committed file you have at a particular environment
3. Inline code. You can add a script, where you import `_common_util.sh` and then you simply call `addSubstitution <key> <value>`

In the files, the key/value pair MUST be separated by a colon. And I don't trim

## Overriding Substitutions

There is an order to how the substitutions are applied, and each layer is applied over the top of the other. This allows us to have defaults, and then to override them. The order over override is shown below where the lowest number (1) has the highest priority
1. Calling `addSubstitution <key> <value>`
2. envconfig file
3. defaults.txt

### Overriding defaults

Create file .envconfig and override what you need. It is in the format :

```bash
<key>:<value>
```

You can enclose the value in quotes if needed. eg 

```bash
blah:"valueinhere"
```

#### Things to watch

In the yaml files we use keys in this format {{key}} and it is suggested to do the same. This is how Helm does it...
- Don't use spaces! I don't trim the string
- Don't use colons! It is the separator character. I didnt use = because of base64 encodings


