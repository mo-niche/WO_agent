# powershell script for updating capabilities of existing context

# step 1: fetch existing context from current user subscription. The name of the context used here is Mehoopany-Context
$context = $(az workload-orchestration context show --subscription $subId --resource-group Mehoopany --name Mehoopany-Context) | ConvertFrom-JSON
 
# step 2: add new context capabilities
# ask user for a list of capabilities they want to add
# suppose if they enter 2 capabilities <capability 1> and <capability 2>, update the capabilties as shown in next line:
$context.properties.capabilities = $context.properties.capabilities + @(
   [PSCustomObject]@{description="<capability 1>"; name="<capability 1>"},
   [PSCustomObject]@{description="<capability 2>"; name="<capability 2>"}
)
# make changes to the above code based on number of capabilities user adds
$context.properties.capabilities = $context.properties.capabilities | Select-Object -Property name, description -Unique
$context.properties.capabilities | ConvertTo-JSON -Compress | Set-Content context-capabilities.json

# step 3: finally update the context
az workload-orchestration context create `
  --subscription $subId `
  --resource-group Mehoopany `
  --location eastus2euap `
  --name Mehoopany-Context `
  --capabilities "@context-capabilities.json" `
  --hierarchies [0].name=country [0].description=Country [1].name=region [1].description=Region [2].name=factory [2].description=Factory [3].name=line [3].description=Line
