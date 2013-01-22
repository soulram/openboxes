<%@page import="org.pih.warehouse.core.ActivityCode"%>
<%@page import="org.pih.warehouse.shipping.Shipment"%>
<style>
	
	.menu-subheading { 
		font-weight: bold;
		padding-bottom: 5px;
		display: block;
	}
</style>
<ul class="megamenu">
	<g:authorize activity="[ActivityCode.MANAGE_INVENTORY]">
	
		
		
		<li>
			<g:link controller="inventory" action="browse">
				<warehouse:message code="inventory.label" />&nbsp;
			</g:link>
			<div>
				<div class="buttonsBar">
					
					<div class="megaButton">
						<g:link controller="inventory" action="browse" class="browse" params="[resetSearch:true]">
							<warehouse:message code="inventory.browseAllProducts.label"/>
						</g:link>
					</div>		
					
					<g:if test="${session.lastProduct }" >
						<div class="megaButton">
							<g:link controller="inventoryItem" action="showStockCard" id="${session.lastProduct.id }" class="product">
								<img src="${createLinkTo(dir:'images/icons',file:'indent.gif')}" class="middle" />
								${session.lastProduct.name }
							</g:link>					
						</div>
					</g:if>
					
					<div class="megaButton">
						<g:link controller="inventory" action="browse" class="browse" params="[resetSearch:true]"><warehouse:message code="inventory.browseByCategory.label"/></g:link>
					</div>
					<div style="max-height: 200px; overflow: auto;">
						<g:if test='${quickCategories }'>
							<g:each var="category" in="${quickCategories}">
								<div class="megaButton">
									<g:link class="outline" controller="inventory" action="browse" params="[categoryId:category.id,resetSearch:true]">
										<img src="${createLinkTo(dir:'images/icons',file:'indent.gif')}" class="middle" />
										<format:category category="${category}"/> (${category?.products?.size() })
									</g:link>
								</div>
								<g:if test="${category.categories}">
									<g:each var="childCategory" in="${category.categories}">
										<div class="megaButton">
											<g:link class="indent" controller="inventory" action="browse" params="[categoryId:childCategory.id,resetSearch:true]">
												<img src="${createLinkTo(dir:'images/icons',file:'indent.gif')}" class="middle" />
												<format:category category="${childCategory}"/> (${childCategory?.products?.size() })
											</g:link>
										</div>
									</g:each>	
								</g:if>
							</g:each>	
						</g:if>	
						<g:elseif test='${categories }'>
							<g:each var="entry" in="${categories}">
								<div class="megaButton">
									<g:link class="outline" controller="inventory" action="browse" params="[categoryId:entry.key.id,resetSearch:true]">
										<img src="${createLinkTo(dir:'images/icons',file:'indent.gif')}" class="middle" />
										${entry.key } (${entry?.key?.products?.size() }) 
									</g:link>
								</div>
								<g:each var="category" in="${entry.value }">
									<div class="megaButton">
										<g:link class="indent" controller="inventory" action="browse" params="[categoryId:category.id,resetSearch:true]">
											<img src="${createLinkTo(dir:'images/icons',file:'indent.gif')}" class="middle" />
											${category } (${category.products.size() })
										</g:link>
									</div>
								</g:each>
							</g:each>
						</g:elseif>	
					</div>				
				</div>			
			</div>				
		</li>
	</g:authorize>
	
	<g:authorize activity="[ActivityCode.PLACE_ORDER,ActivityCode.FULFILL_ORDER]">	
		<li>
			<g:link controller="order" action="list" class="list">			
				<warehouse:message code="orders.label"/>
			</g:link>
			<div class="buttonsBar">
				<div class="megaButton">
					<g:link controller="order" action="list" params="[status:'PENDING']" class="list"><warehouse:message code="order.list.label"/></g:link>
				</div>
				<g:each in="${incomingOrders}" var="orderStatusRow">
					<div class="megaButton">
						<g:link controller="order" action="list" params="[status:orderStatusRow[0]]" class="order-status-${orderStatusRow[0] }">
							<img src="${createLinkTo(dir:'images/icons',file:'indent.gif')}" class="middle" />
							<format:metadata obj="${orderStatusRow[0]}"/> (${orderStatusRow[1]})
						</g:link>
					</div>					
				</g:each>
				<div class="megaButton">							
					<g:link controller="purchaseOrderWorkflow" action="index" class="create">
						<warehouse:message code="order.create.label"/>
					</g:link>
				</div>										
			</div>
		</li>
	</g:authorize>
	<g:authorize activity="[ActivityCode.PLACE_REQUEST,ActivityCode.FULFILL_REQUEST]">
		<li>
			<g:link controller="requisition" action="list">
				<warehouse:message code="requests.label"/>
			</g:link>
			<div>
                <div class="buttonsBar">
                    <div class="megaButton">
                        <g:link controller="requisition" action="list" class="list">
                            <warehouse:message code="requisition.list.label" /> (${incomingRequests?.values()?.flatten()?.size()?:0 })
                        </g:link>
                    </div>
	                <div class="megaButton">
	                    <g:link controller="requisition" action="create" class="create" params="[type:'WARD_STOCK']">
	                        <warehouse:message code="requisition.create.label" args="[warehouse.message(code:'requisitionType.ward-stock.label')]" />
	                    </g:link>
	                </div>
	
	                <div class="megaButton">
	                    <g:link controller="requisition" action="create" class="create" params="[type:'WARD_NON_STOCK']">
	                        <warehouse:message code="requisition.create.label" args="[warehouse.message(code:'requisitionType.ward-non-stock.label')]" />
	                    </g:link>
	                </div>
	
	                <div class="megaButton">
	                    <g:link controller="requisition" action="create" class="create" params="[type:'DEPOT_STOCK']">
	                        <warehouse:message code="requisition.create.label" args="[warehouse.message(code:'requisitionType.depot-stock.label')]" />
	                    </g:link>
	                </div>
	
	                <div class="megaButton">
	                    <g:link controller="requisition" action="create" class="create" params="[type:'DEPOT_NON_STOCK']">
	                        <warehouse:message code="requisition.create.label" args="[warehouse.message(code:'requisitionType.depot-non-stock.label')]" />
	                    </g:link>
	                </div>
	        	</div>
			</div>
		</li>
	</g:authorize>		
	
	<g:authorize activity="[ActivityCode.SEND_STOCK]">
		<li>
			<g:link controller="shipment" action="list" params="[type:'outgoing']">
				<warehouse:message code="shipping.label" />
			</g:link>
			<div class="buttonsBar">
				<div class="megaButton">
					<g:link controller="shipment" action="list" params="[type:'outgoing']" class="list"><warehouse:message code="shipping.listOutgoing.label"  default="List outgoing shipments"/></g:link>
				</div>					
				<g:each in="${outgoingShipments}" var="statusRow">
					<div class="megaButton">
						<g:link controller="shipment" action="list" params="[status:statusRow.key]" class="shipment-status-${statusRow.key }">
							<img src="${createLinkTo(dir:'images/icons',file:'indent.gif')}" class="middle" />
							<format:metadata obj="${statusRow.key}"/> (${statusRow.value.size()})
						</g:link>
					</div>
				</g:each>
				<div class="megaButton">					
					<g:link controller="createShipmentWorkflow" action="createShipment" params="[type:'OUTGOING']" class="create"><warehouse:message code="shipping.createOutgoingShipment.label"/></g:link>
				</div>	
			</div>
		</li>
	</g:authorize>		
	<g:authorize activity="[ActivityCode.RECEIVE_STOCK]">		
		<li>
			<g:link controller="shipment" action="list" params="[type: 'incoming']">
				<warehouse:message code="receiving.label" />
			</g:link>

			<div class="buttonsBar">
				<div class="megaButton">
					<g:link controller="shipment" action="list" params="[type: 'incoming']" class="list"><warehouse:message code="shipping.listIncoming.label"  default="List incoming shipments"/></g:link>
				</div>
				<g:each in="${incomingShipments}" var="statusRow">
					<div class="megaButton">
						<g:link controller="shipment" action="list" params="[type: 'incoming', status:statusRow.key]" class="shipment-status-${statusRow.key }">
							<img src="${createLinkTo(dir:'images/icons',file:'indent.gif')}" class="middle" />
							<format:metadata obj="${statusRow.key}"/> (${statusRow.value.size()})
						</g:link>
					</div>
				</g:each>					
				<div class="megaButton">						
					<g:link controller="createShipmentWorkflow" action="createShipment" params="[type:'INCOMING']" class="create"><warehouse:message code="shipping.createIncomingShipment.label"/></g:link>
				</div>							
			</div>
		</li>		
	</g:authorize>			
	<li>
		<a href="javascript:void(0)">
			<warehouse:message code="report.label" />
		</a>
		<div class="buttonsBar">
			<div class="megaButton">
				<g:link controller="report" action="showTransactionReport" class="report_inventory"><warehouse:message code="report.showTransactionReport.label"/></g:link>							
			</div>
			<div class="megaButton">
				<g:link controller="inventory" action="showConsumption" class="report_consumption"><warehouse:message code="inventory.consumption.label"/></g:link> 
			</div>
			<div class="megaButton">
				<g:link controller="inventory" action="listDailyTransactions" class="report_transactions"><warehouse:message code="transaction.dailyTransactions.label"/></g:link> 
			</div>
			<div class="megaButton">
				<g:link controller="report" action="showShippingReport" class="report_shipping"><warehouse:message code="report.showShippingReport.label"/></g:link>
			</div>
			<div>
				<hr/>
			</div>
			<div class="megaButton">
				<g:link controller="inventory" action="listExpiredStock" class="report_expired"><warehouse:message code="inventory.expiredStock.label"/></g:link> 
			</div>
			<div class="megaButton">
				<g:link controller="inventory" action="listExpiringStock" class="report_expiring"><warehouse:message code="inventory.expiringStock.label"/></g:link> 
			</div>
			<div class="megaButton">
				<g:link controller="inventory" action="listLowStock" class="report_low"><warehouse:message code="inventory.lowStock.label"/></g:link> 
			</div>
			<div class="megaButton">
				<g:link controller="inventory" action="listReorderStock" class="report_reorder"><warehouse:message code="inventory.reorderStock.label"/></g:link> 
			</div>
		</div>					
	</li>
	<g:isUserAdmin>
		<li><a href="javascript:void(0)"> <warehouse:message
					code="admin.label" />
		</a>
			<div>
				<div class="buttonsBar">
					<g:authorize activity="[ActivityCode.MANAGE_INVENTORY]">
						<div class="megaButton">
							<g:link controller="admin" action="showSettings" class="list">
								<warehouse:message code="default.manage.label"
									args="[warehouse.message(code:'default.settings.label')]" />
							</g:link>
						</div>
					</g:authorize>

					<div class="megaButton">
						<g:link controller="locationGroup" action="list" class="site">
							<warehouse:message code="location.sites.label" />
						</g:link>
					</div>
					<div class="megaButton">
						<g:link controller="location" action="list" class="location">
							<warehouse:message code="locations.label" />
						</g:link>
					</div>
					<div class="megaButton">
						<g:link controller="shipper" action="list" class="shipper">
							<warehouse:message code="location.shippers.label" />
						</g:link>
					</div>
					<div class="megaButton">
						<g:link controller="locationType" action="list"
							class="locationType">
							<warehouse:message code="location.locationTypes.label" />
						</g:link>
					</div>
					<div>
						<hr/>
					</div>
					<div class="megaButton">
						<g:link controller="person" action="list" class="people">
							<warehouse:message code="person.list.label" />
						</g:link>
					</div>					
					<div class="megaButton">
						<g:link controller="user" action="list" class="user">
							<warehouse:message code="users.label" />
						</g:link>
					</div>
					<div>
						<hr/>
					</div>
					<div class="megaButton">
						<g:link controller="inventory" action="listAllTransactions" class="list"><warehouse:message code="transactions.label"/></g:link> 
					</div>										
					<div class="megaButton">
						<g:link controller="inventory" action="editTransaction" class="create"><warehouse:message code="transaction.add.label"/></g:link> 				
					</div>										
					<div class="megaButton">
						<g:link controller="batch" action="importData" params="[type:'inventory']" class="inventory"><warehouse:message code="default.import.label" args="[warehouse.message(code:'inventory.label')]"/></g:link> 				
					</div>					
					
					
				</div>
			</div>
		</li>
	</g:isUserAdmin>


	<g:authorize activity="[ActivityCode.MANAGE_INVENTORY]">	
		<li>
			<a href="javascript:void(0)">
				<warehouse:message code="products.label" />
			</a>				
			<div>				
				<div class="buttonsBar">						
					<div class="megaButton">									
						<g:link controller="product" action="list" class="list"><warehouse:message code="products.label"/></g:link>
					</div>
					<div class="megaButton">									
						<g:link controller="productGroup" action="list" class="list"><warehouse:message code="productGroups.label"/></g:link>
					</div>
					<div class="megaButton">									
						<g:link controller="attribute" action="list" class="list"><warehouse:message code="attributes.label"/></g:link>
					</div>
					<div class="megaButton">									
						<g:link controller="category" action="tree" class="list"><warehouse:message code="categories.label"/></g:link>
					</div>
					<div class="megaButton">									
						<g:link controller="tag" action="list" class="list"><warehouse:message code="product.tags.label"/></g:link>
					</div>					
					<div class="megaButton">
						<g:link controller="unitOfMeasure" action="list" class="list"><warehouse:message code="unitOfMeasure.label"/></g:link> 				
					</div>										
					<div class="megaButton">
						<g:link controller="unitOfMeasureClass" action="list" class="list"><warehouse:message code="unitOfMeasureClass.label"/></g:link> 				
					</div>		
					<g:isUserAdmin>
						<div>
							<hr/>
						</div>
						<div class="megaButton">
							<g:link controller="product" action="create" class="create"><warehouse:message code="product.create.label"/></g:link>
						</div>
						<div class="megaButton">
							<g:link controller="createProductFromTemplate" action="index" class="create"><warehouse:message code="product.createFromTemplate.label"/></g:link>
						</div>
						<div class="megaButton">
							<g:link controller="createProduct" action="index" class="create"><warehouse:message code="product.createFromGoogle.label"/></g:link>
						</div>
						<div>
							<hr/>
						</div>
						<div class="megaButton">
							<g:link controller="product" action="importAsCsv" class="import"><warehouse:message code="product.importAsCsv.label"/></g:link>
						</div>
						<div class="megaButton">
							<g:link controller="product" action="exportAsCsv" class="list"><warehouse:message code="product.exportAsCsv.label"/></g:link> 
						</div>
					
					</g:isUserAdmin>						
				</div>
			</div>
		</li>
	</g:authorize>	
	
</ul>
<!--MegaMenu Ends-->
