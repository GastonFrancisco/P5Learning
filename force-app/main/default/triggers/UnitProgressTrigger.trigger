trigger UnitProgressTrigger on Unit_Progress__c (after update) {
    if(Trigger.isAfter){
        UnitProgressTriggerHelper.updateUserUnitProg(Trigger.new);
    }
}