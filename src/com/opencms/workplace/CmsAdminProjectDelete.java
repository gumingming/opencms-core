/*
* File   : $Source: /alkacon/cvs/opencms/src/com/opencms/workplace/Attic/CmsAdminProjectDelete.java,v $
* Date   : $Date: 2002/12/06 23:16:47 $
* Version: $Revision: 1.15 $
*
* This library is part of OpenCms -
* the Open Source Content Mananagement System
*
* Copyright (C) 2001  The OpenCms Group
*
* This library is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* This library is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* For further information about OpenCms, please see the
* OpenCms Website: http://www.opencms.org
*
* You should have received a copy of the GNU Lesser General Public
* License along with this library; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

package com.opencms.workplace;

import com.opencms.boot.I_CmsLogChannels;
import com.opencms.core.A_OpenCms;
import com.opencms.core.CmsException;
import com.opencms.core.I_CmsConstants;
import com.opencms.core.I_CmsSession;
import com.opencms.file.CmsObject;
import com.opencms.file.CmsProject;

import java.util.Hashtable;

/**
 * Template class for displaying OpenCms workplace admin project resent.
 * <P>
 *
 * @author Andreas Schouten
 * @version $Revision: 1.15 $ $Date: 2002/12/06 23:16:47 $
 * @see com.opencms.workplace.CmsXmlWpTemplateFile
 */

public class CmsAdminProjectDelete extends CmsWorkplaceDefault implements I_CmsConstants,I_CmsLogChannels {

    private final String C_DELETE_THREAD = "deleteprojectthread";

    /**
     * Gets the content of a defined section in a given template file and its subtemplates
     * with the given parameters.
     *
     * @see getContent(CmsObject cms, String templateFile, String elementName, Hashtable parameters)
     * @param cms CmsObject Object for accessing system resources.
     * @param templateFile Filename of the template file.
     * @param elementName Element name of this template in our parent template.
     * @param parameters Hashtable with all template class parameters.
     * @param templateSelector template section that should be processed.
     */

    public byte[] getContent(CmsObject cms, String templateFile, String elementName, Hashtable parameters,
            String templateSelector) throws CmsException {
        if(I_CmsLogChannels.C_PREPROCESSOR_IS_LOGGING && A_OpenCms.isLogging() && C_DEBUG) {
            A_OpenCms.log(C_OPENCMS_DEBUG, this.getClassName() + "getting content of element "
                    + ((elementName == null) ? "<root>" : elementName));
            A_OpenCms.log(C_OPENCMS_DEBUG, this.getClassName() + "template file is: "
                    + templateFile);
            A_OpenCms.log(C_OPENCMS_DEBUG, this.getClassName() + "selected template section is: "
                    + ((templateSelector == null) ? "<default>" : templateSelector));
        }
        CmsXmlWpTemplateFile xmlTemplateDocument = (CmsXmlWpTemplateFile)getOwnTemplateFile(cms,
                templateFile, elementName, parameters, templateSelector);

        CmsProject project = null;
        I_CmsSession session = cms.getRequestContext().getSession(true);
        String action = (String)parameters.get("action");
        String projectId = (String)parameters.get("projectid");
        if(projectId == null || "".equals(projectId)){
            projectId = (String)session.getValue("delprojectid");
        } else {
            session.putValue("delprojectid", projectId);
        }
        if(parameters.get("ok") != null) {
            if(action == null){
                // start the deleting
                project = cms.readProject(Integer.parseInt(projectId));
                // first clear the session entry if necessary
                if(session.getValue(C_SESSION_THREAD_ERROR) != null) {
                    session.removeValue(C_SESSION_THREAD_ERROR);
                }
                // change to the online-project, if needed.
                if(project.equals(cms.getRequestContext().currentProject())) {
                    cms.getRequestContext().setCurrentProject(cms.onlineProject().getId());
                }
                Thread doDelete = new CmsAdminProjectDeleteThread(cms, Integer.parseInt(projectId), session);
                doDelete.start();
                session.putValue(C_DELETE_THREAD, doDelete);
                xmlTemplateDocument.setData("time", "10");
                templateSelector = "wait";
            } else if("working".equals(action)) {
                // still working?
                Thread doDelete = (Thread)session.getValue(C_DELETE_THREAD);
                if(doDelete.isAlive()) {
                    String time = (String)parameters.get("time");
                    int wert = Integer.parseInt(time);
                    wert += 2;
                    xmlTemplateDocument.setData("time", "" + wert);
                    templateSelector = "wait";
                } else {
                    // thread has come to an end, was there an error?
                    String errordetails = (String)session.getValue(C_SESSION_THREAD_ERROR);
                    if(errordetails == null) {
                        // clear the languagefile cache
                        CmsXmlWpTemplateFile.clearcache();
                        templateSelector = "done";
                        session.removeValue("delprojectid");
                    } else {
                        // get errorpage:
                        xmlTemplateDocument.setData("details", errordetails);
                        templateSelector = "error";
                        session.removeValue(C_SESSION_THREAD_ERROR);
                        session.removeValue("delprojectid");
                    }
                }
            }
        } else {
            // show details about the project
            project = cms.readProject(Integer.parseInt(projectId));
            CmsXmlLanguageFile lang = xmlTemplateDocument.getLanguageFile();
            CmsProjectlist.setListEntryData(cms, lang, xmlTemplateDocument, project);

        // Now load the template file and start the processing
        }
        return startProcessing(cms, xmlTemplateDocument, elementName, parameters,
                templateSelector);
    }

    /**
     * Indicates if the results of this class are cacheable.
     *
     * @param cms CmsObject Object for accessing system resources
     * @param templateFile Filename of the template file
     * @param elementName Element name of this template in our parent template.
     * @param parameters Hashtable with all template class parameters.
     * @param templateSelector template section that should be processed.
     * @return <EM>true</EM> if cacheable, <EM>false</EM> otherwise.
     */

    public boolean isCacheable(CmsObject cms, String templateFile, String elementName,
            Hashtable parameters, String templateSelector) {
        return false;
    }
}
