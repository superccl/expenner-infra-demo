async function handler(event) {
  const request = event.request
  const host = request.headers.host.value
  const uri = request.uri

  if (host.startsWith("www.")) {
    var newUrl = "https://" + host.substring(4) + uri
    return {
      statusCode: 301,
      statusDescription: "Moved Permanently",
      headers: {
        location: { value: newUrl },
      },
    }
  }

  // Check whether the URI is missing a file name.
  if (uri.endsWith("/")) {
    request.uri += "index.html"
  }
  // Check whether the URI is missing a file extension.
  else if (!uri.includes(".")) {
    request.uri += "/index.html"
  }
  // Regular expression to match UUIDs
  const uuidRegex =
    /\/([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})\//

  // Replace UUIDs with [id]
  request.uri = request.uri.replace(uuidRegex, "/[id]/")

  return request
}
