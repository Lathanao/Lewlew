/* eslint no-undef: 0 */


import { interpolateTable } from '/js/tool/interpolateTable.js'

import "/wc/datagrid/element/wc-datagrid-view-switcher.js"
import "/wc/datagrid/element/wc-datagrid-button-delete.js"
import "/wc/datagrid/element/wc-datagrid-button.js"
import "/wc/datagrid/element/wc-datagrid-pageview.js"

export class WCDataGridAccount extends WCDataGrid {

}

customElements.define('wc-datagrid-account', WCDataGridAccount)
