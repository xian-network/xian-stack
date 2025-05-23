   # Use the official Node.js image.
   FROM node:14

   # Create and change to the app directory.
   WORKDIR /usr/src/app

   # Install PostGraphile globally.
   RUN npm install -g postgraphile postgraphile-plugin-connection-filter
   RUN npm install -g @graphile/pg-aggregates

   # Expose the port PostGraphile will run on.
   EXPOSE 5000