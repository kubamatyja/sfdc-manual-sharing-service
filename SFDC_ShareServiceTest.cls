@IsTest
public with sharing class SFDC_ShareServiceTest {

    @IsTest
    static void getNotExistsObjectType() {
        try {
            SObjectType type = PC_ShareService.getObjectType('AccountTemp');
        } catch (PC_ShareServiceException ex) {
            System.assertEquals('ObjectType AccountTemp is not exists', ex.message);
        }
    }

    @IsTest
    static void shouldShareRecordsWithUsers() {

    }

}