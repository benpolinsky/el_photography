module MailHelper
  def mail_styles
    %Q{
      <style type='text/css'>
      @import url(https://fonts.googleapis.com/css?family=Open+Sans:400,300,700,300italic,400italic);
      /*////// RESET STYLES //////*/
      body, #bodyTable, #bodyCell {
        height: 100% !important;
        margin: 0;
        padding: 0;
        width: 100% !important;
        background: white !important;
        overflow-x:visible;
        overflow-y:visible;
        font-family: 'Open Sans', Arial, sans-serif;
        font-size:14px;
      }
      a:visited{
        color:#2C9AB7;
      }
    
      p{
        margin:7px 0;
      line-height: 1.4em;
      }
      table {
        border-collapse: collapse;
      }
      img, a img {
        border: 0;
        outline: none;
        text-decoration: none;
      }
      img#hero-image {

        margin-bottom: 40px;
        width:100%;
      }
      #bodyCell.newsletter img#hero-image{
        margin-top:0px;
        margin-bottom:20px;
        max-width:300px;
      }
      
      .darkBand{
        background-color:#30343d;
        height:150px;
        color:white;
        text-transform:uppercase;
        font-weight:700;
        letter-spacing:0.15em;
      }
      .darkBand h2{
        color: white;
        font-size: 29px;
        font-weight: 100;
        text-align: center;
        letter-spacing: 0.1em;
        margin-top: 37px;
      }
      h1, h2, h3, h4, h5, h6 {
        margin: 0;
        padding: 0;
      }
      p {
        margin: 1em 0;
      }
      .text-left{
        text-align:left;
      }
      /*////// CLIENT-SPECIFIC STYLES //////*/
      .ReadMsgBody {
        width: 100%;
      }
      .ExternalClass {
        width: 100%;
      }
      /* Force Hotmail/Outlook.com to display emails at full width. */
      .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div {
        line-height: 100%;
      }
      /* Force Hotmail/Outlook.com to display line heights normally. */
      table, td {
        mso-table-lspace: 0pt;
        mso-table-rspace: 0pt;
      }
      /* Remove spacing between tables in Outlook 2007 and up. */
      #outlook a {
        padding: 0;
      }
      /* Force Outlook 2007 and up to provide a "view in browser" message. */
      img {
        -ms-interpolation-mode: bicubic;
      }
      /* Force IE to smoothly render resized images. */
      body, table, td, p, a, li, blockquote {
        -ms-text-size-adjust: 100%;
        -webkit-text-size-adjust: 100%;
      }
      /* Prevent Windows- and Webkit-based mobile platforms from changing declared text sizes. */

      /*////// FRAMEWORK STYLES //////*/
      .flexibleContainerCell {
        padding-top: 20px;
        padding-Right: 20px;
        padding-Left: 20px;
      }
      .flexibleImage {
        height: auto;
      }
      .bottomShim {

      }
      .imageContent, .imageContentLast {
        padding-bottom: 20px;
      }
      .nestedContainerCell {
        padding-top: 20px;
        padding-Right: 20px;
        padding-Left: 20px;
      }

      /*////// GENERAL STYLES //////*/
      body, #bodyTable {
        background-color: #F5F5F5;
      }
      #bodyCell {
        padding-top: 40px;
        padding-bottom: 40px;
      }
      #bodyCell.newsletter{
        padding-top:0px;
        padding-bottom:0px;
      }
      #bodyCell.newsletter .emailButton{
        background-color:#2C9AB7;
        color:white;
        position:relative;
        margin-top:20px;
        margin-bottom:20px;
        padding-bottom:0px;
        border:0px;
        
      }
      tr.images .flexibleContainerCell{
        padding-top:0px;
        
      }
      #bodyCell.newsletter .buttonContent{
        padding:0 15px;
      }
      #bodyCell.newsletter .buttonContent a{
        color:white;
        line-height:50px;
      }
      #emailBody {
        background-color: #FFFFFF;

        border-collapse: separate;
        border-radius: 4px;
      }
      
      tr.images.newsletter .flexibleContainerCell {
        padding:0px;
      }
      h1, h2, h3, h4, h5, h6 {
        color: #202020;
        font-family: 'Open Sans', sans-serif;
        font-size: 20px;
        line-height: 125%;
        text-align: Left;
      }
      .textContent, .textContentLast {
        color: #404040;
        font-family: 'Open Sans', sans-serif;
        font-size: 16px;
        line-height: 125%;
        text-align: Left;
        padding-bottom: 20px;
      }
      .textContent a, .textContentLast a {
        color: #2C9AB7;
        text-decoration: underline;
      }
      .nestedContainer {
        background-color: #E5E5E5;
        border: 1px solid #CCCCCC;
      }
      .emailButton {
        background-color: #FFFFFF;
        border-collapse: separate;
        border: 1px solid 2C9AB7;
        border-radius: 0px;
      }
      .buttonContent {
        color: #2C9AB7;
        font-family: 'Open Sans', sans-serif;
        font-size: 14px;
        text-transform:uppercase;
        font-weight: bold;
        line-height: 100%;
        padding: 15px;
        text-align: center;
      }
      .buttonContent a {
        color: #2C9AB7;
        font-size: 14px;
        text-transform:uppercase;
        display: block;
        text-decoration: none;
      }
      .emailCalendar {
        background-color: #FFFFFF;
        border: 1px solid #CCCCCC;
      }
      .emailCalendarMonth {
        background-color: #2C9AB7;
        color: #FFFFFF;
        font-family: 'Open Sans', Arial, sans-serif;
        font-size: 16px;
        font-weight: bold;
        padding-top: 10px;
        padding-bottom: 10px;
        text-align: center;
      }
      .emailCalendarDay {
        color: #2C9AB7;
        font-family: 'Open Sans', Arial, sans-serif;
        font-size: 60px;
        font-weight: bold;
        line-height: 100%;
        padding-top: 20px;
        padding-bottom: 20px;
        text-align: center;
      }
      .socialMediaContent a {
        margin-right: 5px;
        margin-left: 5px;
      }
      .socialMediaContent a img {
        width: 32px;
      }
      
      .checkout-order-item{
        width: 100%;
        border-bottom: 1px solid $grey;
        padding: 10px 0px;
        overflow:visible;
        clear: both;
        position: relative;

      }
      hr{
        margin: 50px 50px 40px;
      }
      .checkout-order-total, .checkout-order-subtotal{
        width: 100%;
        border-bottom: 1px solid $grey;
        padding:0px;
        overflow:visible;
        clear: both;
        position: relative;
      }
      .final-addresses p{
        margin:5px 0;
      }
      .final-address{
        margin-bottom:35px;
      }
			/* ========== Column Styles ========== */

			.templateColumnContainer{width:200px;}

			/**
			* @tab Columns
			* @section column style
			* @tip Set the background color and borders for your email's column area.
			*/
			#templateColumns{
				/*@editable*/ background-color:#F4F4F4;
				/*@editable*/ border-top:1px solid #FFFFFF;
				/*@editable*/ border-bottom:1px solid #CCCCCC;
			}

			/**
			* @tab Columns
			* @section left column text
			* @tip Set the styling for your email's left column content text. Choose a size and color that is easy to read.
			*/
			.leftColumnContent{
				/*@editable*/ color:#505050;
				/*@editable*/ font-family:Helvetica;
				/*@editable*/ font-size:14px;
				/*@editable*/ line-height:150%;
				padding-top:0;
				padding-right:20px;
				padding-bottom:20px;
				padding-left:20px;
				/*@editable*/ text-align:left;
			}

			/**
			* @tab Columns
			* @section left column link
			* @tip Set the styling for your email's left column content links. Choose a color that helps them stand out from your text.
			*/
			.leftColumnContent a:link, .leftColumnContent a:visited, /* Yahoo! Mail Override */ .leftColumnContent a .yshortcuts /* Yahoo! Mail Override */{
				/*@editable*/ color:#EB4102;
				/*@editable*/ font-weight:normal;
				/*@editable*/ text-decoration:underline;
			}

			/**
			* @tab Columns
			* @section center column text
			* @tip Set the styling for your email's center column content text. Choose a size and color that is easy to read.
			*/
			.centerColumnContent{
				/*@editable*/ color:#505050;
				/*@editable*/ font-family:Helvetica;
				/*@editable*/ font-size:14px;
				/*@editable*/ line-height:150%;
				padding-top:0;
				padding-right:20px;
				padding-bottom:20px;
				padding-left:20px;
				/*@editable*/ text-align:left;
			}

			/**
			* @tab Columns
			* @section center column link
			* @tip Set the styling for your email's center column content links. Choose a color that helps them stand out from your text.
			*/
			.centerColumnContent a:link, .centerColumnContent a:visited, /* Yahoo! Mail Override */ .centerColumnContent a .yshortcuts /* Yahoo! Mail Override */{
				/*@editable*/ color:#EB4102;
				/*@editable*/ font-weight:normal;
				/*@editable*/ text-decoration:underline;
			}

			/**
			* @tab Columns
			* @section right column text
			* @tip Set the styling for your email's right column content text. Choose a size and color that is easy to read.
			*/
			.rightColumnContent{
				/*@editable*/ color:#505050;
				/*@editable*/ font-family:Helvetica;
				/*@editable*/ font-size:14px;
				/*@editable*/ line-height:150%;
				padding-top:0;
				padding-right:20px;
				padding-bottom:20px;
				padding-left:20px;
				/*@editable*/ text-align:left;
			}

			/**
			* @tab Columns
			* @section right column link
			* @tip Set the styling for your email's right column content links. Choose a color that helps them stand out from your text.
			*/
			.rightColumnContent a:link, .rightColumnContent a:visited, /* Yahoo! Mail Override */ .rightColumnContent a .yshortcuts /* Yahoo! Mail Override */{
				/*@editable*/ color:#EB4102;
				/*@editable*/ font-weight:normal;
				/*@editable*/ text-decoration:underline;
			}

			.leftColumnContent img, .rightColumnContent img{
				display:inline;
				height:auto;
				max-width:260px;
			}
      
      @media only screen and (max-width: 616px) {
				.templateColumnContainer{display:block !important; width:100% !important;}
        table{
          width:100% !important;
          td{
            width:100% !important;
          }
        }
      }      
      
      /*////// MOBILE STYLES //////*/
      @media only screen and (max-width: 480px) {
        /*////// CLIENT-SPECIFIC STYLES //////*/
        body {
          width: 100% !important;
          min-width: 100% !important;
        }
        /* Force iOS Mail to render the email at full width. */

        /*////// FRAMEWORK STYLES //////*/
        /*
        CSS selectors are written in attribute
        selector format to prevent Yahoo Mail
        from rendering media query styles on
        desktop.
        */
        table[id="emailBody"], table[class="flexibleContainer"] {
          width: 100% !important;
        }

        /*
        The following style rule makes any
        image classed with 'flexibleImage'
        fluid when the query activates.
        Make sure you add an inline max-width
        to those images to prevent them
        from blowing out. 
        */
        img[class="flexibleImage"] {
          height: auto !important;
          width: 100% !important;
          max-width:100% !important;
        }

        /*
        Make buttons in the email span the
        full width of their container, allowing
        for left- or right-handed ease of use.
        */
        table[class="emailButton"] {
          width: 100% !important;
        }
        td[class="buttonContent"] {
          padding: 0 !important;
        }
        td[class="buttonContent"] a {
          padding: 15px !important;
        }

        td[class="textContentLast"], td[class="imageContentLast"] {
          padding-top: 20px !important;
        }

        /*////// GENERAL STYLES //////*/
        td[id="bodyCell"] {
          padding-top: 10px !important;
        }
				/* ======== Column Styles ======== */

				.templateColumnContainer{display:block !important; width:100% !important;}

				/**
				* @tab Mobile Styles
				* @section column image
				* @tip Make the column image fluid for portrait or landscape view adaptability, and set the image's original width as the max-width. If a fluid setting doesn't work, set the image width to half its original size instead.
				*/
				.columnImage{
					height:auto !important;
					/*@editable*/ max-width:480px !important;
					/*@editable*/ width:100% !important;
				}

				/**
				* @tab Mobile Styles
				* @section left column text
				* @tip Make the left column content text larger in size for better readability on small screens. We recommend a font size of at least 16px.
				*/
				.leftColumnContent{
					/*@editable*/ font-size:16px !important;
					/*@editable*/ line-height:125% !important;
				}

				/**
				* @tab Mobile Styles
				* @section center column text
				* @tip Make the center column content text larger in size for better readability on small screens. We recommend a font size of at least 16px.
				*/
				.centerColumnContent{
					/*@editable*/ font-size:16px !important;
					/*@editable*/ line-height:125% !important;
				}

				/**
				* @tab Mobile Styles
				* @section right column text
				* @tip Make the right column content text larger in size for better readability on small screens. We recommend a font size of at least 16px.
				*/
				.rightColumnContent{
					/*@editable*/ font-size:16px !important;
					/*@editable*/ line-height:125% !important;
				}
        #bodyCell.newsletter .buttonContent {
          max-width:
        }
        .darkBand h2{
          color: white;
          font-size: 21px;
          font-weight: 100;
          text-align: center;
          letter-spacing: 0.1em;
          margin-top: 37px;
        }
      }
      .unsubscribe-description{
        font-size:10px;
        margin-top:70px;
      }
      .unsubscribe-link{
        font-size:10px;
      }
    </style>
      <!--
      	Outlook Conditional CSS

          These two style blocks target Outlook 2007 & 2010 specifically, forcing
          columns into a single vertical stack as on mobile clients. This is
          primarily done to avoid the 'page break bug' and is optional.

          More information here:
		http://templates.mailchimp.com/development/css/outlook-conditional-css
      -->
      <!--[if mso 12]>
          <style type="text/css">
          	.flexibleContainer{display:block !important; width:100% !important;}
          </style>
      <![endif]-->
      <!--[if mso 14]>
          <style type="text/css">
          	.flexibleContainer{display:block !important; width:100% !important;}
          </style>
      <![endif]-->
    }
  end
  
  def mail_button(text, link)
    content_tag :table, border: 0, cellpadding: 0, width: 260, class: 'emailButton' do
      content_tag :tr do
        content_tag :td, align: 'center', valign: 'middle', class: "buttonContent" do
          link_to text, link, target: "_blank"
        end
      end
    end
  end
  
  
  def mail_module(options={}, &block)
    class_names = options[:class_names] || ""
    table_align = options[:table_align] || 'center'
    table_width = options[:width] || '600'
    content_tag :tr, class: class_names do
      content_tag :td, align: table_align, valign: 'top' do
        content_tag :table, border: 0, cellpadding: 0, cellspacing: 0, width: table_width do
          content_tag :tr do
            content_tag :td, align: table_align, valign: 'top' do
              content_tag :table, border: 0, cellpadding: 0, cellspacing: 0, width: table_width, class: "flexibleContainer" do
                content_tag :tr do
                  content_tag :td, align: table_align, valign: "top", width: table_width, class: "flexibleContainerCell bottomShim" do
                    yield
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  
  def social_media_module
     mail_module do
       %Q{
         <table border="0" cellpadding="0" cellspacing="0" width="260" class="socialMediaContain">
             <tr>
                 <td align="center" valign="middle" class="socialMediaContent">
                   #{link_to image_tag('http://www.mineraliety.com/instagram.png'),'http://www.instagram.com/mineraliety'}
                   #{link_to image_tag('http://www.mineraliety.com/tumblra.png'),'http://mineraliety.tumblr.com/'}
                   #{link_to image_tag('http://www.mineraliety.com/pinterest.png'),'http://www.pinterest.com/mineraliety'}
                   #{link_to image_tag('http://www.mineraliety.com/twitter.png'),'http://www.twitter.com/mineraliety'}
                   #{link_to image_tag('http://www.mineraliety.com/facebook.png'),'http://www.facebook.com/mineraliety'}
                 </td>
             </tr>
         </table>
       }.html_safe
    end
  end
end