global with sharing class AddOrderProductsController {
    
    // Constructor with StandardController as parameter
    public AddOrderProductsController(ApexPages.StandardController stdCon) {}

    /**
     *  Method
     *  @name getOrderProducts
     *  @param orderId - Id of the Order record where OrderItem are required to be added
     *  @return OrderProduct[] - list of Order Products to be made available for user selection
     */
    @RemoteAction
    global static OrderProduct[] getOrderProducts(Id orderId) {
        OrderProduct[] listOrderProducts = new OrderProduct[]{};

        Order[] orders = [select Id,Opportunity.Id From Order where Id =: orderId];

        Map<String, OrderItem> mapCurrProducts = getExistingOrderProducts(orderId);

        if(orders != null && orders.size() > 0) {
            OrderItem[] orderItems = [select Id, OrderId, PricebookEntryId, PriceBookEntry.Product2Id From OrderItem where OrderId =: orderId];
            OpportunityLineItem[] OptyLineItems = [Select Id, Name, Product2Id, PricebookEntryId, PriceBookEntry.Product2Id From OpportunityLineItem where Opportunity.Id =:orders[0].Opportunity.Id];
            //Product2[] lstProduct = [Select Id From Product2];
            
            //for(OrderItem orderProduct :orderItems) {
            for(OpportunityLineItem oli :OptyLineItems) {    
				Boolean orderProdExists = mapCurrProducts.containsKey(orders[0].Id + '-' + oli.Product2Id);
            	
                PricebookEntry pbookEntry = [Select Id, Product2Id From PricebookEntry where Id =: oli.PricebookEntryId];
                Product2 prod = [Select Id, Name, ProductCode, Family from Product2 where Id =: pbookEntry.Product2Id];
                
                OrderProduct orderProd = new OrderProduct();
                orderProd.isSelected = orderProdExists ? true : false;
                orderProd.order = orders[0];
                orderProd.product = prod;  //oli.PriceBookEntry.Product2;
                orderProd.pbEntry = pbookEntry;
                listOrderProducts.add(orderProd);
            }
        }
		
        return listOrderProducts;
    }

    /**
     *  Method
     *  @name setOrderProducts
     *  @param orderId - Id of the Order record where products are required to be added
     *  @param orderProducts - List of OrderItem with selection information
     *  @return Boolean - flag to indicate the result of the process/operation
     */     
    @RemoteAction
    global static Boolean setOrderProducts(Id orderId, OrderProduct[] orderProducts) {
        system.debug('orderProducts'+ orderProducts);
        Map<String, OrderItem> mapCurrProducts = getExistingOrderProducts(orderId);

        OrderItem[] listProductsToAdd = new OrderItem[]{},
            listProductsToRemove = new OrderItem[]{};

        for(OrderProduct orderProduct : orderProducts) {
            String currOrderProdKey = orderProduct.Order.Id + '-' + orderProduct.product;

            if(orderProduct.isSelected == false && mapCurrProducts.containsKey(currOrderProdKey)) {
                listProductsToRemove.add(mapCurrProducts.get(currOrderProdKey));
            }
            else if(orderProduct.isSelected == true && !mapCurrProducts.containsKey(currOrderProdKey)) {
                
                PricebookEntry pbookEntry = [Select Id, Product2Id From PricebookEntry where Id =: orderProduct.pbEntry.Id];
                //Product2 prod = [Select Id, name from Product2 where Id =: pbookEntry.Product2Id];
                
                OrderItem orderPrd = new OrderItem();
                orderPrd.PricebookEntryId = pbookEntry.Id;
                orderPrd.Quantity = 10;
                orderPrd.orderId = orderId;
                //orderPrd.Product2 = cp.product.Id;
                listProductsToAdd.add(orderPrd);
            }
        }

        try {
            insert listProductsToAdd;
            delete listProductsToRemove;
        }
        catch(Exception ex){
            throw ex;
        }

        return true;
    }

    /**
     *  Method
     *  @name getExistingOrderProducts
     *  @param orderId - Id of the Order record for whicih existing OrderItem records has to be fetched
     *  @return Map<String, OrderItem> - Map of the existing OrderItem records
     */
    private static Map<String, OrderItem> getExistingOrderProducts(Id orderId){
        Map<String, OrderItem> mapCurrentOrderProducts = new Map<String, OrderItem>();

        for(OrderItem orderProduct  : [Select Id, PriceBookEntry.Product2Id, PriceBookEntry.Product2.ProductCode, PriceBookEntry.Product2.Family, OrderId From OrderItem where OrderId =: orderId]){
            String recordKey = orderProduct.OrderId + '-' + PriceBookEntry.Product2Id;
            mapCurrentOrderProducts.put(recordKey, orderProduct);
        }
		System.debug('#mapCurrentOrderProducts' + mapCurrentOrderProducts);
        return mapCurrentOrderProducts;
    }

    /* Wrapper class to be used as javascript remoting object */
    global class OrderProduct {
		global Boolean isSelected {get;set;}
        global Order order {get;set;}
        global Product2 product {get;set;}
        global PricebookEntry pbEntry {get;set;}
    }    
}