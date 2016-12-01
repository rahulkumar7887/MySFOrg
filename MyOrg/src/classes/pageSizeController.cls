public with sharing class pageSizeController {

    public pageSizeController(ApexPages.StandardSetController controller) {
        controller.setPageSize(5);
    }
}