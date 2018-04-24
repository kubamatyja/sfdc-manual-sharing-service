
public with sharing class SFDC_ShareService {

    public enum AccessLevel {
        Edit,
        Read,
        All
    }

    private String objectName;
    private String objectShareName;
    private String accessLevelString;
    private SObjectType objectType;

    public SFDC_ShareService(String objectName, AccessLevel accessLevel) {
        this.objectName = objectName;
        this.objectShareName = objectName + 'Share';
        this.accessLevelString = accessLevel.name();
    }

    private void getObjectType(String objectName) {
        this.objectType = Schema.getGlobalDescribe().get(objectName);
        if(this.objectType == null) {
            throw new NullPointerException();
        }
    }

    public List<SObject> ShareRecordWithUserOrGroup(Set<Id> recordIds, List<SObject> usersOrGroupList) {
        getObjectType(objectShareName);
        if(recordIds.isEmpty() || usersOrGroupList.isEmpty()) {
            throw new NullPointerException();
        }
        List<SObject> listObject = new List<SObject>();
        for(SObject sObj : usersOrGroupList) {
            PrepareRecordsShareRecords(listObject, recordIds, Id.valueOf((String)sObj.get('Id')));
        }
        return listObject;
    }

    private void PrepareRecordsShareRecords(list<SObject> resultList, Set<Id> recordIds, Id userOrGroupId) {
        for(Id idItem : recordIds) {
            SObject newObject = this.objectType.newSObject();
            newObject.put('UserOrGroupId', userOrGroupId);
            newObject.put(this.objectName + 'Id', idItem);
            newObject.put('LeadAccessLevel', this.accessLevelString);
            resultList.add(newObject);
        }
    }
}