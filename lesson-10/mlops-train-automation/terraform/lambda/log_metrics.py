def handler(event, context):
    print("Logging metrics...")

    return {
        "status": "logged",
        "message": "Metrics successfully recorded"
    }