/******************************************************************************
 *         Hardware accelerated Functional Verification of Processor          *
 ******************************************************************************/
/**
 *  \file   netcope_transaction.sv
 *  \date   09-03-2013
 *  \brief  Definition of sequence with input data in the form of NetCOPE transactions
 */


// NetCOPETransaction class
class NetCOPETransaction extends ovm_sequence_item;

    // Public Class Atributes 

    // NetCOPE header
    byte endpointID       = 0;  //! hardware endpoint indentification
    byte endpointProtocol = 0;  //! hardware endpoint protocol
    byte transType        = 0;  //! transaction type (data, control)
    byte ifcProtocol      = 0;  //! interface protocol
    byte ifcInfo          = 0;  //! support interface information
    
    // transported data 
    byte unsigned data[];
    
    // size of transported data
    int size = 0;

    // registration of component tools
    `ovm_component_utils_begin( NetCOPETransaction )
    `ovm_component_utils_end

    // Constructor - creates new instance of this class
    function new( string name, ovm_component parent );
        super.new( name, parent );

    endfunction : new

    // build - instantiates child components
    function void build;
        super.build();
    endfunction: build

    // Function displays the current values of the transaction or data described
    // by this instance in a human-readable format on the standard output.
    // \param prefix - transaction type
    virtual function void display(string prefix = "");
        if (prefix != "") begin
          $write("---------------------------------------------------------\n");
          $write("-- %s\n",prefix);
          $write("---------------------------------------------------------\n");
        end
      
        $write("endpointID: %x\n",endpointID);
        $write("endpointProtocol: %x\n",endpointProtocol);
      
        if (transType == 0) $write("Data transaction: %x\n",transType);
        else if (transType == 1) $write("Control START transaction: %x\n",transType);
        else if (transType == 2) $write("Control WAIT transaction: %x\n",transType);
        else if (transType == 3) $write("Control WAITFOREVER transaction: %x\n",transType);
        else if (transType == 4) $write("Control STOP transaction: %x\n",transType);
        else if (transType == 5) $write("Control SRC_RDY transaction: %x\n",transType);
      
        $write("ifcProtocol: %x\n",ifcProtocol);
        $write("ifcInfo: %x\n",ifcInfo);
        $write("\n");
      
        for (int j=0; j < data.size; j++) begin 
          $write("%x ",data[j]);
        end  
        
        $write("\n");    
    endfunction : display

endclass: NetCOPETransaction
