import csv
import json
import logging
from pathlib import Path



BASE_DIR = Path(__file__).resolve().parent.parent # get the parent directory of the current file
print(BASE_DIR)
customer_data_path = BASE_DIR / "Day2_deliverable" / "raw" / "customers.csv" # create a path object for the csv file
product_data_path = BASE_DIR / "Day2_deliverable" / "raw" / "products.json" # create a path object for the json file
customer_output_path = BASE_DIR / "Day2_deliverable" / "processed" / "valid_customers.csv" # create a path object for the output csv file
product_output_path = BASE_DIR / "Day2_deliverable" / "processed" / "valid_products.json" # create a path object for the output json file
customer_log_path = BASE_DIR / "Day2_deliverable" / "logs" / "customer_validation.log" # create a path object for the log file
product_log_path = BASE_DIR / "Day2_deliverable" / "logs" / "product_validation.log" # create a path object for the log file


# Set up logging configuration
def create_logger(name: str, log_file: Path) -> logging.Logger:
    """
    Create a logger with the specified name and log file.
    Args:
        name (str): The name of the logger.
        log_file (Path): The path to the log file.
    Returns:
        logging.Logger: The configured logger.
    """
    logger = logging.getLogger(name)
    logger.setLevel(logging.INFO)

    handler = logging.FileHandler(filename=log_file, encoding="utf-8")
    handler.setLevel(logging.INFO)

    formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(name)s - %(message)s")

    handler.setFormatter(formatter)
    logger.addHandler(handler)
    return logger

# Create directories if they don't exist
(BASE_DIR / "processed").mkdir(parents=True, exist_ok=True)
(BASE_DIR / "logs").mkdir(parents=True, exist_ok=True)

# create loggers for customer and product validation
product_logger = create_logger("product_validation", product_log_path)
customer_logger = create_logger("customer_validation", customer_log_path)

def validate_customer_data(row: dict) -> bool:
    """
    Validate the customer data row.
    Args:
        row (dict): A dictionary representing a row of customer data.
    Returns:
        bool: True if the row is valid, False otherwise.
    """
    # Check if all required fields are present
    required_fields = ["customer_id", "name", "location", "created_at"]
    for field in required_fields:
        if field not in row or not row[field] or not field.strip() or not row[field].strip():
            print(f"Missing or empty field: {field} in row: {row}")
            return False
    return True

def validate_product_data(product:dict) -> bool:
    """
    Validate the product data.
    Args:
        product (dict): A dictionary representing a product.
    Returns:
        bool: True if the product is valid, False otherwise.
    """
    # required fields for product data
    required_fields = ["product_id", "product_name", "category", "price"]
    for field in required_fields:
        value = product.get(field)

        if value is None or not str(value).strip():
            print(f"Missing or empty field: {field} in product: {product}")
            return False
    return True

def write_valid_rows_to_csv(valid_rows: list, output_path: Path):
    """
    Write the valid rows to a new CSV file.
    Args:
        valid_rows (list): A list of dictionaries representing valid rows of customer data.
        output_path (Path): The path to the output CSV file.
    """
    fields = ["customer_id", "name", "location", "created_at"]
    with open(output_path, "w", encoding="utf-8", newline="") as customer_output_file:
        writer = csv.DictWriter(customer_output_file, fieldnames=fields)
        writer.writeheader()
        for row in valid_rows:
            writer.writerow(row)
    return

def write_valid_products_to_json(valid_products: list, output_path: Path):
    """
    Write the valid products to a new JSON file.
    Args:
        valid_products (list): A list of dictionaries representing valid products.
        output_path (Path): The path to the output JSON file.
    """
    with open(output_path, "w", encoding="utf-8") as product_output_file:
        json.dump(valid_products, product_output_file, indent=2, ensure_ascii=False)



def main():
    """
    Main function to execute the script.
    """
    passed_customers = 0 # initialize a counter for the number of valid rows
    failed_customers = 0 # initialize a counter for the number of invalid rows
    passed_products = 0 # initialize a counter for the number of valid products
    failed_products = 0 # initialize a counter for the number of invalid products

    valid_customers = []
    valid_products = []

    # Read customer data, write the valid rows to a new CSV file, and log the number of valid and invalid rows
    with customer_data_path.open("r", encoding="utf-8", newline="") as customer_data:
        reader = csv.DictReader(customer_data) # read the csv file as a dictionary
        for row in reader:
            if validate_customer_data(row):
                print(f"Valid row: {row}")
                valid_customers.append(row)

                # write_valid_rows_to_csv(row, customer_output_path)
                customer_logger.info(f"Valid row: {row}")
                passed_customers += 1
            else:
                print(f"Invalid row: {row}")
                customer_logger.warning(f"Invalid row: {row}")
                failed_customers += 1

    # Read product data, write the valid products to a new JSON file, and log the number of valid and invalid products
    with product_data_path.open(encoding="utf-8") as product_data:
        products = json.load(product_data) # load the json file as a dictionary
        for product in products:
            if validate_product_data(product):
                print(f"Valid product: {product}")
                valid_products.append(product)

                # write_valid_products_to_json(product, product_output_path)
                product_logger.info(f"Valid product: {product}")
                passed_products += 1
            else:
                print(f"Invalid product: {product}")
                product_logger.warning(f"Invalid product: {product}")
                failed_products += 1

    # Write the valid customers to a new CSV file
    if valid_customers:
        write_valid_rows_to_csv(valid_customers, customer_output_path)

    # Write the valid products to a new JSON file
    if valid_products:
        write_valid_products_to_json(valid_products, product_output_path)

    # Log summaries
    customer_logger.info(
        "Customers | Total: %d | Passed: %d | Failed: %d",
        passed_customers + failed_customers,
        passed_customers,
        failed_customers
    )

    product_logger.info(
        "Products | Total: %d | Passed: %d | Failed: %d",
        passed_products + failed_products,
        passed_products,
        failed_products
    )

if __name__ == "__main__":
    main()