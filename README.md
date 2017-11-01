# MoodleTemplate
repository containing cloudformation templates to create highly available moodle implementation & infrastructure.
testing pull from VSCode plugin for source control

**NOTE- How To Test This In development**

For changes in the userdata script below are the (hacky) steps to test changes without having to delete and deploy a new stack (which takes upwards of 15 minutes)

Step1: Make Change (Wow, you're welcome for that tip /s)  
Step2: Update name of AWS::EC2::Instance resource  
Step3: Update any other reference to AWS::EC2::Instance resource, for instance AWS::ElasticLoadBalancing::LoadBalancer  
***Pro-tip.  Step 2 and 3 can be done with a simple find and replace =O***
