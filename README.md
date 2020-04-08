# GitHubSearcher
GitHubSearcher iOS App

Note to reviewer:

First off, this little assignment project I've built definitely has scope for further improvement. Due to time constraint, I'd 
like to stop my work here and submit for review.

I've used my personal embedded OAuth token to workaround the GitHub API rate limiting. You can see the hardcoded token 
in the APIService class. Please note that it still doesn't give you the privilge of unlimted requests. It has only enabled 
us to push the rate-cap a bit further. So at some point while using the application, you may a see 403 error being 
printed on the console.

Also, I am listing some of the items I would've worked on or improved had I given more time.

1. More abstraction to the viewcontrollers by adding a router component for navigation
2. Error handlers & Alerts at appropriate places
3. Pagination to repo search as well
4. Code cleanup & refactoring wherever possible

and many more. I look forward to have a discussion with you soon. :)

Thanks
Deepak



