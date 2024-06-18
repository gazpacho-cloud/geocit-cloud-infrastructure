import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("newadmin", "password123")
hudsonRealm.createAccount("newuser", "pass456")
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

instance.save()

def admin1 = instance.getUser("newadmin")
admin1.addProperty(new HudsonPrivateSecurityRealm.Details().fromPlain("John Doe", "john@example.com"))

def admin2 = instance.getUser("newuser")
admin2.addProperty(new HudsonPrivateSecurityRealm.Details().fromPlain("Jane Smith", "jane@example.com"))

def authenticatedUsers = instance.getAuthorizationStrategy().getAuthenticatedUsers()
authenticatedUsers.add("newadmin")
authenticatedUsers.add("newuser")

instance.save()