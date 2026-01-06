/* File: mongodb_operations.js
   Student Task: NoSQL Database Analysis
*/

// Operation 1: Load Data (1 mark)
// In a real environment, we might use 'mongoimport --file products_catalog.json'
// For this script, we will insert the data directly to ensure the code runs standalone.
db.products.drop(); // Clear collection if it exists to avoid duplicates
db.products.insertMany([
  {
    "product_id": "ELEC001",
    "name": "Samsung Galaxy S21 Ultra",
    "category": "Electronics",
    "price": 79999.00,
    "stock": 150,
    "specifications": { "ram": "12GB", "storage": "256GB", "camera": "108MP" },
    "reviews": [
      { "user": "U001", "rating": 5, "comment": "Excellent phone!", "date": "2024-01-15" },
      { "user": "U012", "rating": 4, "comment": "Great but pricey.", "date": "2024-02-10" }
    ]
  },
  {
    "product_id": "ELEC002",
    "name": "Apple MacBook Pro 14-inch",
    "category": "Electronics",
    "price": 189999.00,
    "stock": 45,
    "specifications": { "processor": "M2 Pro", "ram": "16GB" },
    "reviews": [
      { "user": "U005", "rating": 5, "comment": "Perfect for dev work.", "date": "2024-01-20" }
    ]
  },
  {
    "product_id": "ELEC003",
    "name": "Sony WH-1000XM5 Headphones",
    "category": "Electronics",
    "price": 29990.00,
    "stock": 200,
    "specifications": { "noise_cancellation": "Active", "battery_life": "30 hours" },
    "reviews": [
      { "user": "U007", "rating": 5, "comment": "Best noise cancellation.", "date": "2024-01-25" },
      { "user": "U014", "rating": 4, "comment": "Great sound.", "date": "2024-02-20" }
    ]
  },
  {
    "product_id": "ELEC004",
    "name": "Dell 27-inch 4K Monitor",
    "category": "Electronics",
    "price": 32999.00,
    "stock": 60,
    "specifications": { "resolution": "4K", "refresh_rate": "60Hz" },
    "reviews": [
      { "user": "U003", "rating": 5, "comment": "Colors are accurate.", "date": "2024-02-01" },
      { "user": "U021", "rating": 3, "comment": "Not good for gaming.", "date": "2024-03-01" }
    ]
  },
  {
    "product_id": "ELEC005",
    "name": "OnePlus Nord CE 3",
    "category": "Electronics",
    "price": 26999.00,
    "stock": 180,
    "specifications": { "ram": "8GB", "storage": "128GB" },
    "reviews": [
      { "user": "U010", "rating": 4, "comment": "Value for money.", "date": "2024-02-10" }
    ]
  },
  {
    "product_id": "FASH001",
    "name": "Levi's 511 Slim Fit Jeans",
    "category": "Fashion",
    "price": 3499.00,
    "stock": 120,
    "specifications": { "material": "Cotton", "fit": "Slim", "sizes": ["30", "32", "34"] },
    "reviews": [
      { "user": "U002", "rating": 5, "comment": "Perfect fit.", "date": "2024-01-18" }
    ]
  },
  {
    "product_id": "FASH002",
    "name": "Nike Air Max 270 Sneakers",
    "category": "Fashion",
    "price": 12995.00,
    "stock": 85,
    "specifications": { "brand": "Nike", "type": "Running Shoes" },
    "reviews": [
      { "user": "U004", "rating": 5, "comment": "Super comfortable.", "date": "2024-01-22" }
    ]
  },
  {
    "product_id": "FASH003",
    "name": "Adidas Originals T-Shirt",
    "category": "Fashion",
    "price": 1499.00,
    "stock": 200,
    "specifications": { "material": "Cotton", "fit": "Regular" },
    "reviews": [
      { "user": "U006", "rating": 4, "comment": "Good quality.", "date": "2024-02-05" }
    ]
  },
  {
    "product_id": "FASH004",
    "name": "Puma RS-X Sneakers",
    "category": "Fashion",
    "price": 8999.00,
    "stock": 95,
    "specifications": { "material": "Mesh", "type": "Casual" },
    "reviews": [
      { "user": "U009", "rating": 4, "comment": "Stylish.", "date": "2024-02-12" }
    ]
  },
  {
    "product_id": "FASH005",
    "name": "H&M Slim Fit Formal Shirt",
    "category": "Fashion",
    "price": 1999.00,
    "stock": 150,
    "specifications": { "material": "Cotton blend", "fit": "Slim" },
    "reviews": [
      { "user": "U011", "rating": 4, "comment": "Good for office.", "date": "2024-02-08" }
    ]
  }
]);
print("Operation 1: Data Loaded successfully.");

// Operation 2: Basic Query (2 marks)
// Find all products in "Electronics" category with price less than 50000
// Return only: name, price, stock
print("\n--- Operation 2: Basic Query ---");
var queryResult = db.products.find(
    { 
        "category": "Electronics", 
        "price": { $lt: 50000 } 
    },
    { 
        "name": 1, 
        "price": 1, 
        "stock": 1, 
        "_id": 0 
    }
);
// In Mongo Shell scripts, we iterate cursor to print
queryResult.forEach(printjson);


// Operation 3: Review Analysis (2 marks)
// Find all products that have average rating >= 4.0
// Use aggregation to calculate average from reviews array
print("\n--- Operation 3: Review Analysis ---");
var reviewAnalysis = db.products.aggregate([
    {
        $addFields: {
            "average_rating": { $avg: "$reviews.rating" }
        }
    },
    {
        $match: {
            "average_rating": { $gte: 4.0 }
        }
    },
    {
        // Simple projection for cleaner output
        $project: { "name": 1, "average_rating": 1, "_id": 0 }
    }
]);
reviewAnalysis.forEach(printjson);


// Operation 4: Update Operation (2 marks)
// Add a new review to product "ELEC001"
print("\n--- Operation 4: Update Operation ---");
db.products.updateOne(
    { "product_id": "ELEC001" },
    {
        $push: {
            "reviews": {
                "user": "U999",
                "rating": 4,
                "comment": "Good value",
                "date": new Date()
            }
        }
    }
);
print("Update complete. Checking ELEC001 reviews:");
db.products.find({ "product_id": "ELEC001" }, { "reviews": 1, "_id": 0 }).forEach(printjson);


// Operation 5: Complex Aggregation (3 marks)
// Calculate average price by category
// Sort by avg_price descending
print("\n--- Operation 5: Complex Aggregation ---");
var complexAgg = db.products.aggregate([
    {
        $group: {
            "_id": "$category",
            "avg_price": { $avg: "$price" },
            "product_count": { $sum: 1 }
        }
    },
    {
        $sort: { "avg_price": -1 }
    },
    {
        $project: {
            "category": "$_id",
            "avg_price": 1,
            "product_count": 1,
            "_id": 0
        }
    }
]);
complexAgg.forEach(printjson);