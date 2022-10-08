public with sharing class Example{

        Id userId = UserInfo.getUserId(); //Es el user.Id de la persona que ejecuta este metodo

    List<Module__c> moduleId = [SELECT Id, (SELECT Name, Id FROM Units__r WHERE Id = 'a033t00000hML0QAAW'), (SELECT Name, Id FROM Modules_Progress__r WHERE User__c = :userId)
                            FROM Module__c WHERE Id IN (SELECT Module__c FROM Unit__c WHERE Id = 'a033t00000hML0QAAW')];

    // Utilizamos un query en Module__c porque es el padre de los dos objetos de los cuales necesitamos datos. Unit__c.Id y Module_Progress__c.Id

    Map<Id, Id> mProgressByUnit = new Map<Id, Id>();
    //Como key guardo el Id de Unit__c y como value el Id de Module_Progress__c

    for(Module__c mod: moduleId){
        Id valorone;
        Id valortwo;
        System.debug(mod.Units__r);
        System.debug(mod.Modules_Progress__r);
        for(Unit__c unit: mod.Units__r){
            if(!mProgressByUnit.containsKey(unit.Id)){
                valorone = unit.Id;
        }
    }
        for(Module_Progress__c mpro: mod.Modules_Progress__r){
            valortwo = mpro.Id;
        }
        mProgressByUnit.put(valorone ,valortwo);
    }
    System.debug(unitByModule);
}

