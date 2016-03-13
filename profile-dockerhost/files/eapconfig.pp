#####################################
#                                   #
#  JBoss EAP tuning                 #
#                                   #
#####################################

# Stateless Session Beans Max Pool Size
$slsb_max_pool_size = 40

exec {'stateless session beans pool size':
  command =>  "/bin/sed -i \"s/name=\\\"slsb-strict-max-pool\\\" max-pool-size=\\\"20\\\"/name=\\\"slsb-strict-max-pool\\\" max-pool-size=\\\"$slsb_max_pool_size\\\"/g\" /home/jbosseap/eap/jboss-eap-6.4/standalone/configuration/standalone.xml"
}

# 
exec {'soft limits':
  command =>  "/bin/echo \"* soft nofile 4096\" >> /etc/security/limits.conf"
}

exec {'hard limits':
  command =>  "/bin/echo \"* hard nofile 4096\" >> /etc/security/limits.conf"
}
