@IsTest
public with sharing class SFDC_ShareServiceTest {

 private static SFDC_ShareService createShareService(SFDC_ShareService.AccessLevel al) {
        return new SFDC_ShareService('Lead', al);
    }

    @IsTest
    static void shouldThrowNullPointerExceptionObjectNotExists() {
        try {
            SFDC_ShareService shareService = new SFDC_ShareService('AccountTemp', SFDC_ShareService.AccessLevel.Edit);
            shareService.ShareRecordWithUserOrGroup(new Set<Id>(), new List<SObject>());
            System.assert(false);
        } catch (NullPointerException ex) {
            System.assert(true);
        }
    }

    @IsTest
    static void shouldThrowNullPointerExceptionInputSetOrListIsEmpty() {
        try {
            SFDC_ShareService shareService = createShareService(SFDC_ShareService.AccessLevel.Edit);
            shareService.ShareRecordWithUserOrGroup(new Set<Id>(), new List<SObject>());
            System.assert(false);
        } catch (NullPointerException ex) {
            System.assert(true);
        }
    }

    @IsTest
    static void shouldReturnShareListForOneUser() {
        try {
            SFDC_ShareService shareService = createShareService(SFDC_ShareService.AccessLevel.Edit);
            List<User> us = [SELECT Id FROM User LIMIT 1];
            List<SObject> resultList = shareService.ShareRecordWithUserOrGroup(new Set<Id>{
                    '00D1F000000CqyvUAC'
            }, us);
            System.assertEquals(1, resultList.size());
            System.assertEquals('00D1F000000CqyvUAC', resultList[0].get('LeadId'));
            System.assertEquals(us[0].Id, resultList[0].get('UserOrGroupId'));
            System.assertEquals(SFDC_ShareService.AccessLevel.Edit.name(), resultList[0].get('LeadAccessLevel'));
        } catch (NullPointerException ex) {
            System.assert(false);
        }
    }

    @IsTest
    static void shouldReturnShareForManyUserAndOneObject() {
        try {
            SFDC_ShareService shareService = createShareService(SFDC_ShareService.AccessLevel.Read);
            List<User> us = [SELECT Id FROM User LIMIT 3];
            List<SObject> resultList = shareService.ShareRecordWithUserOrGroup(new Set<Id>{
                    '00D1F000000CqyvUAC', '0011F000004yLkFQAU', '0011F000004zeLpQAI', '0011F000004yOr6QAE'
            }, us);
            System.assertEquals(12, resultList.size());
        } catch (NullPointerException ex) {
            System.assert(false);
        }
    }

    @IsTest
    static void shouldReturnShareForManyUserAndManyObject() {
        try {
            SFDC_ShareService shareService = createShareService(SFDC_ShareService.AccessLevel.Edit);
            List<User> us = [SELECT Id FROM User LIMIT 3];
            List<SObject> resultList = shareService.ShareRecordWithUserOrGroup(new Set<Id>{
                    '00D1F000000CqyvUAC'
            }, us);
            System.assertEquals(3, resultList.size());
            for (SObject objectItem : resultList) {
                System.assertEquals('00D1F000000CqyvUAC', objectItem.get('LeadId'));
                System.assertEquals(SFDC_ShareService.AccessLevel.Edit.name(), objectItem.get('LeadAccessLevel'));
            }
        } catch (NullPointerException ex) {
            System.assert(false);
        }
    }
}