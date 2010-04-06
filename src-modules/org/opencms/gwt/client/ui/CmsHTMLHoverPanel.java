/*
 * File   : $Source: /alkacon/cvs/opencms/src-modules/org/opencms/gwt/client/ui/Attic/CmsHTMLHoverPanel.java,v $
 * Date   : $Date: 2010/04/06 08:23:43 $
 * Version: $Revision: 1.2 $
 *
 * This library is part of OpenCms -
 * the Open Source Content Management System
 *
 * Copyright (C) 2002 - 2009 Alkacon Software (http://www.alkacon.com)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * For further information about Alkacon Software, please see the
 * company website: http://www.alkacon.com
 *
 * For further information about OpenCms, please see the
 * project website: http://www.opencms.org
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

package org.opencms.gwt.client.ui;

import com.google.gwt.event.dom.client.HasMouseOutHandlers;
import com.google.gwt.event.dom.client.HasMouseOverHandlers;
import com.google.gwt.event.dom.client.MouseOutEvent;
import com.google.gwt.event.dom.client.MouseOutHandler;
import com.google.gwt.event.dom.client.MouseOverEvent;
import com.google.gwt.event.dom.client.MouseOverHandler;
import com.google.gwt.event.shared.HandlerRegistration;
import com.google.gwt.user.client.ui.HTMLPanel;

/**
 * A HTML Panel implementation toggles the I_CmsStateCss.cmsHovering CSS class on mouse over.<p>
 * 
 * @author Tobias Herrmann
 * 
 * @version $Revision: 1.2 $
 * 
 * @since 8.0.0
 */
public class CmsHTMLHoverPanel extends HTMLPanel implements HasMouseOutHandlers, HasMouseOverHandlers {

    /**
     * Creates an HTML hover panel with the specified HTML contents inside a DIV element. Any element within this HTML that has a specified id can contain a child widget.
     * 
     * @param html the panel's HTML
     */
    public CmsHTMLHoverPanel(String html) {

        super(html);
        CmsHoverHandler handler = new CmsHoverHandler(this);
        addMouseOutHandler(handler);
        addMouseOverHandler(handler);

    }

    /**
     * Creates an HTML hover panel whose root element has the given tag, and with the specified HTML contents. Any element within this HTML that has a specified id can contain a child widget.
     * 
     * @param tag the tag of the root element
     * @param html the panel's HTML
     */
    public CmsHTMLHoverPanel(String tag, String html) {

        super(tag, html);
        CmsHoverHandler handler = new CmsHoverHandler(this);
        addMouseOutHandler(handler);
        addMouseOverHandler(handler);
    }

    /**
     * @see com.google.gwt.event.dom.client.HasMouseOutHandlers#addMouseOutHandler(com.google.gwt.event.dom.client.MouseOutHandler)
     */
    public HandlerRegistration addMouseOutHandler(MouseOutHandler handler) {

        return this.addDomHandler(handler, MouseOutEvent.getType());

    }

    /**
     * @see com.google.gwt.event.dom.client.HasMouseOverHandlers#addMouseOverHandler(com.google.gwt.event.dom.client.MouseOverHandler)
     */
    public HandlerRegistration addMouseOverHandler(MouseOverHandler handler) {

        return this.addDomHandler(handler, MouseOverEvent.getType());
    }
}