public with sharing class UnitProgressTriggerHelper {
    public static void updateUserUnitProg ( List<Unit_Progress__c> triggerNew) {
      
        Set<Id> unitIds = new Set<Id>();
        for(Unit_Progress__c unit: triggerNew){
            if(unit.Status__c == 'Answered'){
                unitIds.add(unit.Id);
            }
        }
        if(unitIds.size() != 0){

            List<Unit_Progress__c> unitProgressQuery = [SELECT Id, Name, Status__c, Counter__c, Points__c, User__c, (SELECT Id, Option__c, Option__r.IsCorrect__c FROM Questions_Progress__r) FROM Unit_Progress__c WHERE Id IN :unitIds];
            
            //Este set ↓ va a contener los User Ids obtenidos en la lista unitProgressQuery[linea 12], que estan vinculados con los Units_Progress__c. Estos Ids sirven para asegurarnos de que en usersFromUnitProgress[linea 22] llegen los mismos usuarios que recibimos como relacion(User__c) en unitProgressQuery[linea 12]
            Set<Id> userSet = new Set<Id>();
            
            for(Unit_Progress__c uProgress: unitProgressQuery){
                userSet.add(uProgress.User__c);
            }
            
            //Necesitamos esta lista para poder setear los Points__c de User ↓
            List<User> usersFromUnitProgress = [SELECT Points__c, (SELECT Id FROM Units_Progress__r) FROM USER WHERE Id IN: userSet];

            
            //Este mapa ↓ vincula los mismos Ids de Unit_Progress__c que nos llegan en unitProgressQuery[linea 12], y que tambien pedimos en usersFromUnitProgress[linea 22], con los Users correctos(para poder hacer los loops[linea 27 y 28] y que correspondan). Esto va a servir para que cuando estemos haciendo loops[linea 34 y 35] sobre los registros que pedimos en unitProgressQuery[linea 12](Unit_Progress__c y Question_Progress__c) tambien podamos setear los Points__c de los Users correspondientes).
            Map<Id, Integer> userIndexByUnitProgress = new Map<Id, Integer>();
            for(User user: usersFromUnitProgress){
                for(Unit_Progress__c unitPro: user.Units_Progress__r){
                    userIndexByUnitProgress.put(unitPro.Id, usersFromUnitProgress.indexOf(user));
                }
            }

            if(unitProgressQuery.size() != 0 ){
                for(Unit_Progress__c unitProgress : unitProgressQuery){
                    for(Question_Progress__c question : unitProgress.Questions_Progress__r) {
                        if(question.Option__r.IsCorrect__c){
                            unitProgress.Status__c = 'Success';
                            if(userIndexByUnitProgress.containsKey(unitProgress.Id)){
                                //Le pedimos al mapa userIndexByUnitProgress[linea 26] a traves de cada key(Id de UnitProgress[linea 34]) obtenida en las iteracionnes de unitProgress[linea 34] que nos devuelva un indice. Esto permite setear Points__c de cada User y que esten correctamente relacionados
								usersFromUnitProgress[userIndexByUnitProgress.get(unitProgress.Id)].Points__c += unitProgress.Points__c;
                            }
                        } else if(!question.Option__r.IsCorrect__c && unitProgress.Counter__c <= 2){
                            unitProgress.Status__c = 'Fail';
                            unitProgress.Counter__c ++ ;
                            unitProgress.Points__c = unitProgress.Points__c/2;
                        }else if(!question.Option__r.IsCorrect__c && unitProgress.Counter__c >= 3){
                            unitProgress.Status__c = 'Fail';
                            unitProgress.Counter__c ++ ;
                        }
                    }
                }
            }
            update unitProgressQuery;
            update usersFromUnitProgress;
        }
    }
}
//Vuelta 1 erra la opcion entra en el else if chequea si la opcion es distinto de correcta y si el contador es menor o igual a 2 se setea en fail ,el contador aumenta uno y se setea en 2 , finalmente se resta la mitad de puntos 50. 
//Vuelta 2 erra la opcion entra en el else if chequea si la opcion es distinto de correcta y si el contador es menor o igual a 2 se setea en fail ,el contador aumenta uno y se setea en 3 , finalmente se resta la mitad de puntos 25.
//Vuelta 3 erra la opcion entra en el else if 
                    