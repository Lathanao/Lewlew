<div class="dropdown relative inline-block text-left">
 
      <button type="button" class="inline-flex justify-center shadow-sm px-4 py-2 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-100 focus:ring-indigo-500" id="options-menu" aria-haspopup="true" aria-expanded="true">
        <svg xmlns="http://www.w3.org/2000/svg"
            class="icon icon-tabler icon-tabler-dots-vertical dropbtn" width="28"
            height="28" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor"
            fill="none" stroke-linecap="round" stroke-linejoin="round">
            <path stroke="none" d="M0 0h24v24H0z" />
            <circle cx="12" cy="12" r="1" />
            <circle cx="12" cy="19" r="1" />
            <circle cx="12" cy="5" r="1" />
        </svg>
      </button>

  
    <!--
      Dropdown panel, show/hide based on dropdown state.
  
      Entering: "transition ease-out duration-100"
        From: "transform opacity-0 scale-95"
        To: "transform opacity-100 scale-100"
      Leaving: "transition ease-in duration-75"
        From: "transform opacity-100 scale-100"
        To: "transform opacity-0 scale-95"
    -->

    <div class="menu transition ease-out duration-100 transform opacity-0 scale-95 origin-top-right absolute right-0 mt-2 w-36 z-10 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 hidden">
      <div class="py-1" role="menu" aria-orientation="vertical" aria-labelledby="options-menu">
        <a href="/catalog/product/@product.id" class="block px-4 py-2 text-sm hover:bg-gray-100 hover:text-gray-900" role="menuitem">
          <i class="fad fa-edit text-xs mr-1"></i>
          Edit @product.id
        </a>
        <a href="/product/@product.id" class="block px-4 py-2 text-sm hover:bg-gray-100 hover:text-gray-900" role="menuitem">
          <i class="fad fa-eye text-xs mr-1"></i> 
          Preview
        </a>
        <a href="/catalog/product/delete/@product.id" class="block px-4 py-2 text-sm hover:bg-gray-100 hover:text-gray-900" role="menuitem">
          <i class="fad fa-trash-alt text-xs mr-1"></i> 
          Delete
        </a>
      </div>
    </div>
  </div>
</div>