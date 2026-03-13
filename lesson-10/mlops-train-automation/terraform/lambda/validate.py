def handler(event, context):
    print("Validating input data...")

    source = event.get("source", "unknown")

    return {
        "status": "valid",
        "validated_source": source
    }