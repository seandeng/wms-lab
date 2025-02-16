record some ideas about wms system


| Module Name              | Description                                  | Database Tables                              |
|--------------------------|----------------------------------------------|----------------------------------------------|
| **wms-core-service**     | Core management service for warehouse, storer, and product management | `Storer`, `Facility`, `Product`             |
| **wms-inventory-service** | Inventory management, handling stock increases and decreases | `Inventory`                                  |
| **wms-transaction-service** | Transaction management, including inbound and outbound operations | `Inbound`, `Outbound`                        |
| **wms-billing-service**   | Billing management, handling cost calculations | `Billing`, `Billing_Detail`, `Billing_Rate` |
| **wms-auth-service**      | Authentication service, managing user permissions | `users`, `roles`, `permissions`             |
| **wms-gateway-service**   | API gateway for routing & load balancing   | No database                                  |

