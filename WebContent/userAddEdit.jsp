<%@page import="model.*"%>
<%@page import="model.ConferenceFilters.ConferencePreDefinedFilter"%>
<%@page import="daos.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="model.User"%>
<%@page import="helpers.ProjConst"%>
<%@page import="helpers.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%= UiHelpers.GetAllJsAndCss().toString() %>
<style type="text/css">
div.message {
	background: transparent url(/conf4u/resources/imgs/msg_arrow.gif)
		no-repeat scroll left center;
	padding-left: 7px;
}

div.error {
	background-color: #F3E6E6;
	border-color: #924949;
	border-style: solid solid solid none;
	border-width: 2px;
	padding: 4px;
}
</style>

</head>

<body>
<%
User viewingUser = SessionUtils.getUser(request);
String action = request.getParameter("action");
 Boolean isAddParticipant = action != null && action.equals("addParticipant");
 
 String confName = request.getParameter("confName");
 Conference viewerConference = null;
 if (confName != null)
	 viewerConference =  ConferenceDao.getInstance().getConferenceByName(confName);
 ConferencesUsers viewerConferenceUser = null;
 if (viewerConference != null)
 {
	 viewerConferenceUser = ConferencesUsersDao.getInstance().getConferenceUser(viewerConference, viewingUser);
 }
%>
<% Boolean isEdit = action != null && action.equals("edit");
   User user = null;

   String userIdStr = request.getParameter("userId");
   
   if (isEdit)
   {
	   if(userIdStr != null){
		   Long userId = new Long(userIdStr);
		   user = UserDao.getInstance().getUserById(userId);
	   }
   }
%>
<% 

String retUrlPrevPage = (String)getServletContext().getAttribute("retUrl");
boolean isSelfEdit = isEdit && user != null && user.getUserId() == viewingUser.getUserId();
if (!viewingUser.isAdmin())
{
	if (!isSelfEdit)
	{
		if (!isAddParticipant ||  viewerConferenceUser == null || viewerConferenceUser.getUserRole() !=  UserRole.CONF_MNGR.getValue())
		{
			if (ConferencesUsersDao.getInstance().getUserHighestRole(viewingUser).getValue() == UserRole.RECEPTIONIST.getValue())
			{
				response.sendRedirect("reception.jsp");	
				return;
			}
			response.sendRedirect(retUrlPrevPage);
			return;
		}
	}
}

getServletContext().setAttribute("retUrl", request.getRequestURL().toString());
%>

<%= UiHelpers.GetHeader(viewingUser).toString() %>
<%= UiHelpers.GetTabs(viewingUser, ProjConst.TAB_USERS).toString() %>
<div id="content">
	<div class="pageTitle">

		<div class="<%=ProjConst.OPERATION%>" style="display:none;"><%=action%></div>
		
		<%
			String oldUserNameStr;
			if(isEdit){
				oldUserNameStr = user.getUserName();
			}else{
				oldUserNameStr = "-1";
			}
		%>
		
		<div class="<%=ProjConst.OLD_USER_NAME%>" style="display:none;"><%=oldUserNameStr%></div>
		<div class="<%=ProjConst.CONF_NAME%>" style="display:none;"><%=request.getParameter("confName")%></div>
		
		<%
			long userId;
			if(isEdit){
				userId = user.getUserId();
			}else{
				userId = -1L;
			}
		%>
		<div class="<%=ProjConst.USER_ID%>" style="display:none;"> <%=userId%> </div>
		
		<% if (isAddParticipant) {%>
			<div class="titleMain ">Add participant</div>
			<div style="clear: both;"></div>
			<div class="titleSeparator"></div>
			<div class="titleSub">Add new participant</div>
		<%} else if (isEdit) {%>
			<div class="titleMain ">Edit user</div>
			<div style="clear: both;"></div>
			<div class="titleSeparator"></div>
			<div class="titleSub">Edit existing user</div>
		<% } else {%>
			<div class="titleMain ">Add user</div>
			<div style="clear: both;"></div>
			<div class="titleSeparator"></div>
			<div class="titleSub">Add a new user</div>
		<%} %>
	</div>
	<div id="vn_mainbody">
		<div class="formtable_wrapper">
			<form id="userAddEditForm">
				<table class="formtable" cellspacing="0" cellpadding="0" border="0">
					<thead>
						<tr>
							<% if (isAddParticipant) {%>
							<th class="header" colspan="2"><strong>Add participant</strong> <br></th>
							<%} else if (isEdit) {%>
							<th class="header" colspan="2"><strong>Edit user</strong> <br></th>
							<% } else {%>
							<th class="header" colspan="2"><strong>Create a new user</strong> <br></th>
							<%} %>
						</tr>
					</thead>
					<tbody>
						
						<tr>
							<td class="labelcell required"><label
								for=<%=ProjConst.USER_NAME%>> Unique User Name: <em>*</em>
							</label></td>
							<% if (isEdit) {%>
								<td class="inputcell">
									<input id="<%=ProjConst.USER_NAME%>" type="text" value="<%=user.getUserName()%>" name="<%=ProjConst.USER_NAME%>" readonly="readonly">
								</td>
							<% } else {%>
								<td class="inputcell">
									<input id="<%=ProjConst.USER_NAME%>" type="text" name="<%=ProjConst.USER_NAME%>">
								</td>
							<%} %>
						</tr>
					
						<tr>
							<td class="labelcell required"><label
								for=<%=ProjConst.NAME%>> Full Name: <em>*</em>
							</label></td>
							<% if (isEdit) {%>		
								<td class="inputcell">
									<input id="<%=ProjConst.NAME%>" type="text" value="<%=user.getName()%>" name="<%=ProjConst.NAME%>">
								</td>
							<% } else {%>
								<td class="inputcell">
									<input id="<%=ProjConst.NAME%>" type="text" name="<%=ProjConst.NAME%>">
								</td>
							<%} %>
						</tr>
			
						<tr>
							<td class="labelcell required"><label
								for=<%=ProjConst.PASSPORT_ID%>> Passport #: <em>*</em>
							</label></td>
							<% if (isEdit) {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PASSPORT_ID%>" type="text" value="<%=user.getPasportID()%>" name="<%=ProjConst.PASSPORT_ID%>">
								</td>
							<% } else {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PASSPORT_ID%>" type="text" name="<%=ProjConst.PASSPORT_ID%>">
								</td>
							<%} %>
						</tr>
	 
						<tr>
							<td class="labelcell required">
								<label for=<%=ProjConst.EMAIL%>> Email:  <em>*</em> </label>
							</td>
							<% if (isEdit) {%>
								<td class="inputcell">
									<input id="<%=ProjConst.EMAIL%>" type="text" value="<%=user.getEmail()%>" name="<%=ProjConst.EMAIL%>">
								</td>								
							<% } else {%>
								<td class="inputcell">
									<input id="<%=ProjConst.EMAIL%>" type="text" name="<%=ProjConst.EMAIL%>">
								</td>
							<%} %>
						</tr>
						
					
						<tr>
							<td class="labelcell required">
								<label for=<%=ProjConst.PHONE1%>> Phone #1:  <em>*</em> </label>
							</td>
							<% if (isEdit) {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PHONE1%>" type="text" value="<%=user.getPhone1()%>" name="<%=ProjConst.PHONE1%>">
								</td>
							<% } else {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PHONE1%>" type="text" name="<%=ProjConst.PHONE1%>">
								</td>
							<%} %>
						</tr>
						
						<tr>
							<td class="labelcell required">
								<label for=<%=ProjConst.PHONE2%>> Phone #2:  </label>
							</td>
							<% if (isEdit) {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PHONE2%>" type="text" value="<%=user.getPhone2()%>" name="<%=ProjConst.PHONE2%>">
								</td>
							<% } else {%>
								<td class="inputcell">
									<input id="<%=ProjConst.PHONE2%>" type="text" name="<%=ProjConst.PHONE2%>">
								</td>
							<%} %>
						</tr>
						
						<tr>
							<td class="labelcell required">
								<label for="<%=ProjConst.COMPANY%>"> Company: <em>*</em> </label>
							</td>
							<td class="inputcell">
								<select id="<%=ProjConst.COMPANY%>" class="type rdOnlyOnEdit" name="<%=ProjConst.COMPANY%>">
									<% 
									List<Company> companies = CompanyDao.getInstance().getAllCompanies();
									for (Company company : companies) { %>
							
									<option value="<%=company.getCompanyID()%>" 
										<% if (isEdit && user.getCompany().getCompanyID() == company.getCompanyID()) {%>
										 	selected="selected"
								 		<%} %>
								 		><%=company.getName()%></option>
					 				<%} %>
								</select>
							</td>
						</tr>
						<% if (!isAddParticipant) {
							if(!isEdit){
						%>
						<tr>
							<td class="labelcell required"><label for=<%=ProjConst.PASSWORD%>> Password: </label></td>
							<td class="inputcell">
								<input id="<%=ProjConst.PASSWORD%>" type="password"  value="" name="<%=ProjConst.PASSWORD%>" autocomplete="off">
							</td>
						</tr>
									<%} %>
						<%} %>

						   <%
								if (viewingUser != null && viewingUser.isAdmin() && !isAddParticipant) {
							%>
									<tr>
										<td class="labelcell required">
											<label for=<%=ProjConst.IS_ADMIN%>> Admin User: <em>*</em> </label>				
										</td>
										<% if (isEdit && user.isAdmin()) {%>
										<td class="inputcell">
											<input id=<%=ProjConst.IS_ADMIN%> type="checkbox" checked="checked" name=<%=ProjConst.IS_ADMIN%>><div></div>
										</td>
										
										<% } else {%>
										<td class="inputcell">
											<input id=<%=ProjConst.IS_ADMIN%> type="checkbox" name=<%=ProjConst.IS_ADMIN%>><div></div>
										</td>
										<%} %>
									</tr>
							<%
								}
							%>
							
							<%
								String redirectTo;
								if(isAddParticipant)
								{
									redirectTo = "conferenceDetails.jsp?conferenceName="+ request.getParameter("confName");
								}
								else if(isEdit)
								{
									redirectTo = "userDetails.jsp?userId="+user.getUserId();
								}else{
								 	redirectTo = "users.jsp";
								}
							%>
						
						<tr>
							<td></td>
							<td class="inputcell">
								<div class="buttons">
									<button id="createButton" type="submit">
										<img class="img_png" width="16" height="16" alt=""
											src="/conf4u/resources/imgs/save.png"> Save
									</button>
									<a id="cancelButton" href="<%=redirectTo %>">
									 <img class="img_png" width="16" height="16" alt="" src="/conf4u/resources/imgs/cancel.png"> Cancel
									</a>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
		<div class="clearboth"></div>
	</div>
	</div>

<script>
$(document).ready(function(){
	
	var addEditUserSubmit = function() {
		$.ajax({
            url: "UsersServlet",
            dataType: 'json',
            async: false,
            type: 'POST',
                data: {
                	"action": $(".operation").text(),
                	<%=ProjConst.OLD_USER_NAME%>: $(".oldUserName").text(),
                	<%=ProjConst.USER_ID%>: $(".userId").text(),
                	<%=ProjConst.USER_NAME%> : $("#userName").val(),
              	 	<%=ProjConst.NAME%> : $("#name").val(),
              	 	<%=ProjConst.PASSPORT_ID%> : $("#passportId").val(),
              	 	<%=ProjConst.PASSWORD%> : $("#password").val(),
              	 	<%=ProjConst.PHONE1%> : $("#phone1").val(), 	
              	 	<%=ProjConst.PHONE2%> : $("#phone2").val(), 	
              	 	<%=ProjConst.EMAIL%> : $("#email").val(), 	
              	 	<%=ProjConst.COMPANY%> : $("#company").val(), 	 
              	 	<%=ProjConst.IS_ADMIN%> : $("#isAdmin").is(':checked') ? "true" :  "false",
              	 	<%=ProjConst.CONF_NAME%> : $(".confName").text() 
                },
            success: function(data) {
                if (data != null){
					if (data.resultSuccess == "true")
					{
						var params;
						var returnUrl;
						
						<%if (redirectTo.contains("?")) {%>
							params = "&messageNotification=" + data.message + "&messageNotificationType=success";
						<% } else {%>
							params = "?messageNotification=" + data.message + "&messageNotificationType=success";						
						<% } %>
						
						returnUrl = "<%=redirectTo%>";
						returnUrl += params;
				 	    window.location.href = returnUrl;
					}
					else
					{
						jError(data.message);
					}
                }
            }
        });
    };
	
	$.validator.addMethod("uniqueUserName", function(value, element) {
		  var is_valid = false;
		  $.ajax({
              url: "UsersServlet",
              dataType: 'json',
              async: false,
              type: 'POST',
                  data: {
                	  "action": "validateUserName",
                  	  <%=ProjConst.OLD_USER_NAME%>: $(".oldUserName").text(),
                	  <%=ProjConst.USER_NAME%> : $("#userName").val(),
                  	  <%=ProjConst.OPERATION%>: $(".operation").text()
                  },
              success: function(data) {
                  if (data != null){
                      if (data == "true")
                      {
                    	 $.validator.messages.uniqueUserName = value + " is already taken";
                       	 is_valid = false;
                      }
                      else
                   	  {
                    	  is_valid = true;
                   	  }
                  }
              }
          });
	      return is_valid;
	 }, "The user name already exists");
	


	 $.validator.addMethod("onlyCharsAndNumbers", function(value, element) {
		 

		 var onlyLetters = /^[a-zA-Z0-9]*$/.test(value);

			if(onlyLetters == true )
      	 		return true;
     	 	else 
     			return false;		 
   }, "User name can include characters or numbers only");
	 
	
	
	 $.validator.addMethod("phone1Validator", function(value, element) {
		 
		 /* allowing + in the beginning (optional) followed by 7-15 digits  */
		 
		 var validPhone = /^\+?\b[0-9,\-]{7,15}\b$/.test(value);

		 if(validPhone == true)
      	 	return true;
   	 	 else 
    		return false;
		 
    }, "Phone number can contain 7-15 digits and might statrt with +");
	 
$.validator.addMethod("phone2Validator", function(value, element) {
		 
	 /* allowing enpty string OR number in the format: + in the beginning (optional) followed by 7-15 digits  */

		 var phoneNumber =  $.trim(value);
		 
		 if(phoneNumber == ""){
			 return true;
		 }
		 
		 var validPhone = /^\+?\b[0-9,\-]{7,15}\b$/.test(value);

		 if(validPhone == true)
      	 	return true;
   	 	 else 
    		return false;	
		 
    }, "Phone number can be empty, or contain 7-15 digits and might statrt with +");
	
	$("#userAddEditForm").validate({
		  onkeyup: false,
		  onfocusout: false,
		  submitHandler: function(form) {  
              if ($(form).valid())
              {
            	  addEditUserSubmit();
              }
              return false;
     		},
		  rules: {
			  <%=ProjConst.USER_NAME%>: {
			    required: true,
			    minlength: 4,
			    maxlength: 10,
			    onlyCharsAndNumbers:true,
			    uniqueUserName: true
			  },
			  <%=ProjConst.NAME%>: {
			  	required: true,
			    minlength: 4,
			    maxlength: 254
			  },
			  <%=ProjConst.PASSPORT_ID%>: {
				  	required: true,
				    minlength: 9,
				    maxlength: 9,
					digits: true
			  },
			  <%=ProjConst.PASSWORD%>: {
				  	required: true,
				    minlength: 4,
				    maxlength: 16
			  },
			  <%=ProjConst.PHONE1%>: {
			  	required: true,
			  	phone1Validator: true
			  },
			  <%=ProjConst.PHONE2%>: {
			  	required: false,
			  	phone2Validator: true
			  },
			  <%=ProjConst.EMAIL%>: {
			  	required: true,
			 	email: true
			  }
		  },
		   
		  messages: {
			  	<%=ProjConst.USER_NAME%>: {
					 required: "Required",
					 minlength: "You need to use at least 4 characters for your user name.",
					 maxlength: "You need to use at most 10 characters for your user name.",
					 uniqueUserName : "This user name already exists",
					 onlyCharsAndNumbers: "User name can include characters or numbers only"
				},
				<%=ProjConst.NAME%>: {
					 required: "Required",
					 minlength: "You need to use at least 4 characters for your name.",
					 maxlength: "You need to use at most 254 characters for your name.",
				},
				<%=ProjConst.PASSPORT_ID%>: {
					 required: "Required",
					 digits: "passport should be consisted of from digits only",
					 minlength: "IL passport id should exactly 9 characters.",
					 maxlength: "IL passport id should exactly 9 characters.",
				},
				<%=ProjConst.PASSWORD%>: {
					required: "Required",
					 minlength: "You need to use 4-16 characters for your password.",
					 maxlength: "You need to use 4-16 characters for your password.",
				 },
				 <%=ProjConst.PHONE1%>: {
					required: "Required",
				 	phoneNumberValidator:"Phone number invalid",
				},
			 	<%=ProjConst.PHONE2%>: {
				 	phoneNumberValidator:"Phone number invalid",
				},
			 	<%=ProjConst.EMAIL%>: {
			 		required: "Required",
			 		email: "Invalid email address",
				}
	  		},
		  errorElement: "div",
	        wrapper: "div",  // a wrapper around the error message
	        errorPlacement: function(error, element) {
	            offset = element.offset();
	            error.insertBefore(element);
	            error.addClass('message');  // add a class to the wrapper
	            error.css('position', 'absolute');
	            error.css('left', offset.left + element.outerWidth());
	        }

		});
});
</script>

</body>
</html>