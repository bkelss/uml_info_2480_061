<cfparam name="qterm" default=''>
<cfparam name="book" default="">
<cftry>
    <cfset addEditFunctions = createObject("addedit") />
    <cfset addEditFunctions.processForms(form)>
    <div class="row">
        <div id="main" class="col-9">
            <cfif book neq "">
                <cfoutput>#mainForm()#</cfoutput>
            </cfif>
        </div>
        <div id=”leftgutter” class="col-lg-3 order-first">
            <cfoutput> #sideNav()# </cfoutput>
        </div>
    </div>
    <cfcatch type="any">
        <cfoutput>
            #cfcatch.Message#
        </cfoutput>
    </cfcatch>
</cftry>


<cffunction name="mainForm">
    <cfset var thisBookDetails= addEditFunctions.bookDetails(book)>
    <cfset allPublishers = addEditFunctions.allPublishers()>
    <cfoutput>
        <form action="#cgi.script_name#?tool=addedit&book=#book#" method="post" enctype="multipart/form-data">
            <div class="form-floating mb-3">
                <input type="text" id="isbn13" name="isbn13" class="form-control" value="#thisBookDetails.isbn13[1]#" placeholder="Please Enter The ISBN13 of the book" />
                <label for="isbn13">ISBN13: </label>
            </div>
            <div class="form-floating mb-3">
                <input type="text" id="title" name="title" class="form-control" value="#thisBookDetails.title[1]#" placeholder="Book Title" />
                <label for="title">Book Title: </label>
            </div>
            <div class="form-floating mb-3">
                <input type="number" id="year" name="year" class="form-control" value="#thisBookDetails.year[1]#" placeholder="Year" />
                <label for="year">year: </label>
            </div>
            <div class="form-floating mb-3">
                <input type="number" id="pages" name="pages" class="form-control" value="#thisBookDetails.pages[1]#" placeholder="Number of Pages" />
                <label for="pages">pages: </label>
            </div>
            <div class="form-floating mb-3">
                <select class="form-select" id="publisher" name="publisher" aria-label="Publisher Select Control">
                    <option ></option>
                    <cfloop query="allPublishers">
                            <option value="#id#" #id eq thisBookDetails.publisher ? "selected" : ""# >#name#</option>
                    </cfloop>
                </select>
                <label for="publisher">Publisher</label>
            </div>
            <label for="uploadImage">Upload Cover</label>
            <div class="input-group mb-3">
                <input type="file" id="uploadImage" name="uploadimage" class="form-control" />
                <input type="hidden" name="image" value="#trim(thisBookDetails.image[1])#" />
            </div>
            <div class="form-floating mb-3">
                <div>
                    <label for="description">Description</label>
                </div>
            <textarea id="description" name="description">
                <cfoutput>#thisBookDetails.description#</cfoutput>
                </textarea>
                <script>
                ClassicEditor
                .create(document.querySelector('##description'))
                    .catch(error => {console.dir(error)});
            </script>
            </div>
            <button type="submit" class="btn btn-primary"  style="width: 100%">Add Book</button>
        </form>
    </cfoutput>
</cffunction>
<cffunction name="sideNav">
    <cfset findBookForm()>
    <cfset allbooks=addEditFunctions.sideNavBooks(qterm)>
    <div>
        Book List
    </div>
    <cfoutput>
        <ul class="nav flex-column">
            <li class="nav-item">
                <a href="#cgi.script_name#?tool=addedit&book=new" class="nav-link">
                    New Book
                </a>
            </li>
            <cfif qterm.len() ==0>
                    No Search Term Entered
                <cfelseif allBooks.recordcount==0>
                    No Results Found
                    Adding Search To Our Management Page 5
            <cfelse>
                <cfloop query="allBooks">
                        <li class="nav-item">
                                <a href="#cgi.script_name#?tool=addedit&book=#isbn13#" class="nav-link">#trim(title)#</a>
                        </li>
                </cfloop>
            </cfif>
        </ul>
    </cfoutput>
</cffunction>
<cffunction name="findBookForm">
    <cfoutput>
        <form action="#cgi.script_name#?tool=#tool#" method="post">
            <div class="form-floating mb-3">
                <input type="text" id="qterm" name="qterm" class="form-control" value="#qterm#" placeholder="Enter a search term to find a book to edit" />
                <label for="qterm">Search Inventory </label>
            </div>
        </form>
    </cfoutput>
</cffunction>
