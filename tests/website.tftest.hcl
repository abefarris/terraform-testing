run "website_test" {
  assert {
    condition     = can(regex("http://.*s3-website.*amazonaws.com", output.website_url))
    error_message = "Website URL format is incorrect"
  }

}

run "website_content_test" {
  assert {
    condition     = can(regex("Hello World!", data.http.website_check.response_body))
    error_message = "Website content is not correct"
  }
}
