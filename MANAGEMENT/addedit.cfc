component {
    function processForms( required struct formData ){
        if ( formData.keyExists( "isbn13" ) && formData.isbn3.len()==13 && formData.title.len() > 0 ) {
            if(formData.keyExists("uploadImage") && formData.uploadImage.len() > 0){
                formData.image = uploadBookCover();
            }
            var qs = new query( datasource = application.dsource );
            qs.setSql( "IF NOT EXISTS( SELECT * FROM books WHERE isbn13=:isbn13)
                INSERT INTO books (isbn13,title) values (:isbn13,:title);
                UPDATE books SET
                    title=:title,
                    year=:year,
                    pages=:pages,
                    publisherId=:publisherId,
                    image=:image,
                    description=:description
                WHERE isbn13=:isbn13");
            qs.addParam(
                name = "isbn13",
                cfsqltype = "CF_SQL_NVARCHAR",
                value = formData.isbn13,
                null=formData.isbn13.len()!=13
            );
            qs.addParam(
                name = "title",
                cfsqltype = "CF_SQL_NVARCHAR",
                value = formData.title,
                null=formData.title.len()==0
            );
            qs.addParam(
                name="year",
                CFSQLTYPE="CF_SQL_NUMERIC",
                value=trim(formData.year),
                null = !isValid('numeric', formData.year)
            );
            qs.addParam(
                name="pages",
                CFSQLTYPE="CF_SQL_NUMERIC",
                value=trim(formData.pages),
                null = !isValid('numeric', formData.pages)
            );
            qs.addParam(
                name = 'publisherId',
                cfsqltype = 'CF_SQL_NVARCHAR',
                value = trim(formData.publisherId),
                null = trim(formData.publisherId).len() != 35
            );
            qs.addParam(
                name="image",
                CFSQLTYPE="CF_SQL_NVARCHAR",
                value=formData.image
            );
            qs.addParam(
                name = 'description',
                cfsqltype = 'CF_SQL_NVARCHAR',
                value = trim(formData.description),
                null = trim(formData.description).len() == 0
            );
            qs.execute();
        }
    }

    function sideNavBooks(){
        if(qterm.len() == 0) {
            return queryNew("title");
        } else {
            var qs = new query( datasource = application.dsource );
            qs.setSql("select * from books where title like :qterm order by title");
            qs.addParam(name="qterm",value="%#qterm#%");
            return qs.execute().getResult();
        }
    }

    function bookDetails(isbn13){
        var qs = new query(datasource=application.dsource);
        qs.setSql("select * from books where isbn13=:isbn13");
        qs.addParam(name="isbn13",CFSQLTYPE="CF_SQL_NVARCHAR",value=arguments.isbn13);
        return qs.execute().getResult();
    }

    function allPublishers(){
        var qs = new query( datasource = application.dsource );
        qs.setSql( "select publisher from books" );
        return qs.execute().getResult();
    }

    function uploadBookCover(){
        var imageData = fileUpload(expandPath("../images/"),"uploadImage","*","makeUnique");
        return imageData.serverFile;
    }
}