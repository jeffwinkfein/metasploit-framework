# -*- coding:binary -*-
require 'spec_helper'

require 'rex/java'
require 'stringio'

describe Rex::Java::Serialization::Model::Stream do

  subject(:stream) do
    described_class.new
  end

  let(:easy_object_stream) do
    "\xac\xed\x00\x05\x73\x72\x00\x04" +
    "\x45\x61\x73\x79\x74\x1d\xe1\xbc" +
    "\xbb\x2f\xcb\xaa\x02\x00\x01\x49" +
    "\x00\x03\x53\x53\x4e\x78\x70\x41" +
    "\x42\x43\x44"
  end
  let(:easy_object_stream_io) { StringIO.new(easy_object_stream) }
  let(:easy_object_stream_to_s) {
    <<-EOS
@magic: 0xaced
@version: 5
@contents: [
  NewObject { Easy => { ["int", 1094861636] } }
]
@references: [
  [7e0000] NewClassDesc { Easy, [ SSN (int) ] }
  [7e0001] NewObject { Easy => { ["int", 1094861636] } }
]
    EOS
  }

  let(:char_array_stream) do
    "\xac\xed\x00\x05\x75\x72\x00\x02" +
    "\x5b\x43\xb0\x26\x66\xb0\xe2\x5d" +
    "\x84\xac\x02\x00\x00\x78\x70\x00" +
    "\x00\x00\x02\x00\x61\x00\x62"
  end
  let(:char_array_stream_io) { StringIO.new(char_array_stream) }
  let(:char_array_stream_to_s) {
    <<-EOS
@magic: 0xaced
@version: 5
@contents: [
  NewArray { char, ["97", "98"] }
]
@references: [
  [7e0000] NewClassDesc { [C, [  ] }
  [7e0001] NewArray { char, ["97", "98"] }
]
    EOS
  }

  let(:complex_stream) do
    "\xac\xed\x00\x05\x77\x22\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00" +
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01" +
    "\xf6\xb6\x89\x8d\x8b\xf2\x86\x43\x75\x72\x00\x18\x5b\x4c\x6a\x61" +
    "\x76\x61\x2e\x72\x6d\x69\x2e\x73\x65\x72\x76\x65\x72\x2e\x4f\x62" +
    "\x6a\x49\x44\x3b\x87\x13\x00\xb8\xd0\x2c\x64\x7e\x02\x00\x00\x70" +
    "\x78\x70\x00\x00\x00\x01\x73\x72\x00\x15\x6a\x61\x76\x61\x2e\x72" +
    "\x6d\x69\x2e\x73\x65\x72\x76\x65\x72\x2e\x4f\x62\x6a\x49\x44\xa7" +
    "\x5e\xfa\x12\x8d\xdc\xe5\x5c\x02\x00\x02\x4a\x00\x06\x6f\x62\x6a" +
    "\x4e\x75\x6d\x4c\x00\x05\x73\x70\x61\x63\x65\x74\x00\x15\x4c\x6a" +
    "\x61\x76\x61\x2f\x72\x6d\x69\x2f\x73\x65\x72\x76\x65\x72\x2f\x55" +
    "\x49\x44\x3b\x70\x78\x70\x0d\xc1\x1e\x2a\x94\x5e\x2f\xb2\x73\x72" +
    "\x00\x13\x6a\x61\x76\x61\x2e\x72\x6d\x69\x2e\x73\x65\x72\x76\x65" +
    "\x72\x2e\x55\x49\x44\x0f\x12\x70\x0d\xbf\x36\x4f\x12\x02\x00\x03" +
    "\x53\x00\x05\x63\x6f\x75\x6e\x74\x4a\x00\x04\x74\x69\x6d\x65\x49" +
    "\x00\x06\x75\x6e\x69\x71\x75\x65\x70\x78\x70\x80\x16\x00\x00\x01" +
    "\x49\xb5\xe4\x92\x78\xd2\x4f\xdf\x47\x77\x08\x80\x00\x00\x00\x00" +
    "\x00\x00\x01\x73\x72\x00\x12\x6a\x61\x76\x61\x2e\x72\x6d\x69\x2e" +
    "\x64\x67\x63\x2e\x4c\x65\x61\x73\x65\xb0\xb5\xe2\x66\x0c\x4a\xdc" +
    "\x34\x02\x00\x02\x4a\x00\x05\x76\x61\x6c\x75\x65\x4c\x00\x04\x76" +
    "\x6d\x69\x64\x74\x00\x13\x4c\x6a\x61\x76\x61\x2f\x72\x6d\x69\x2f" +
    "\x64\x67\x63\x2f\x56\x4d\x49\x44\x3b\x70\x78\x70\x00\x00\x00\x00" +
    "\x00\x09\x27\xc0\x73\x72\x00\x11\x6a\x61\x76\x61\x2e\x72\x6d\x69" +
    "\x2e\x64\x67\x63\x2e\x56\x4d\x49\x44\xf8\x86\x5b\xaf\xa4\xa5\x6d" +
    "\xb6\x02\x00\x02\x5b\x00\x04\x61\x64\x64\x72\x74\x00\x02\x5b\x42" +
    "\x4c\x00\x03\x75\x69\x64\x71\x00\x7e\x00\x03\x70\x78\x70\x75\x72" +
    "\x00\x02\x5b\x42\xac\xf3\x17\xf8\x06\x08\x54\xe0\x02\x00\x00\x70" +
    "\x78\x70\x00\x00\x00\x08\x6b\x02\xc7\x72\x60\x1c\xc7\x95\x73\x71" +
    "\x00\x7e\x00\x05\x80\x01\x00\x00\x01\x49\xb5\xf8\x00\xea\xe9\x62" +
    "\xc1\xc0"
  end
  let(:complex_stream_io) { StringIO.new(complex_stream) }
  let(:complex_stream_to_s) {
    <<-EOS
@magic: 0xaced
@version: 5
@contents: [
  BlockData { [ 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0xf6, 0xb6, 0x89, 0x8d, 0x8b, 0xf2, 0x86, 0x43 ] }
  NewArray { java.rmi.server.ObjID;, ["java.rmi.server.ObjID => { [\\"long\\", 991106561224880050], java.rmi.server.UID => { [\\"short\\", -32746], [\\"long\\", 1416095896184], [\\"int\\", -766517433] } }"] }
  BlockData { [ 0x80, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1 ] }
  NewObject { java.rmi.dgc.Lease => { ["long", 600000], java.rmi.dgc.VMID => { byte, ["107", "2", "-57", "114", "96", "28", "-57", "-107"], 5 => { ["short", -32767], ["long", 1416097169642], ["int", -379403840] } } } }
]
@references: [
  [7e0000] NewClassDesc { [Ljava.rmi.server.ObjID;, [  ] }
  [7e0001] NewArray { java.rmi.server.ObjID;, ["java.rmi.server.ObjID => { [\\"long\\", 991106561224880050], java.rmi.server.UID => { [\\"short\\", -32746], [\\"long\\", 1416095896184], [\\"int\\", -766517433] } }"] }
  [7e0002] NewClassDesc { java.rmi.server.ObjID, [ objNum (long), space (Ljava/rmi/server/UID;) ] }
  [7e0003] Utf { Ljava/rmi/server/UID; }
  [7e0004] NewObject { java.rmi.server.ObjID => { ["long", 991106561224880050], java.rmi.server.UID => { ["short", -32746], ["long", 1416095896184], ["int", -766517433] } } }
  [7e0005] NewClassDesc { java.rmi.server.UID, [ count (short), time (long), unique (int) ] }
  [7e0006] NewObject { java.rmi.server.UID => { ["short", -32746], ["long", 1416095896184], ["int", -766517433] } }
  [7e0007] NewClassDesc { java.rmi.dgc.Lease, [ value (long), vmid (Ljava/rmi/dgc/VMID;) ] }
  [7e0008] Utf { Ljava/rmi/dgc/VMID; }
  [7e0009] NewObject { java.rmi.dgc.Lease => { ["long", 600000], java.rmi.dgc.VMID => { byte, ["107", "2", "-57", "114", "96", "28", "-57", "-107"], 5 => { ["short", -32767], ["long", 1416097169642], ["int", -379403840] } } } }
  [7e000a] NewClassDesc { java.rmi.dgc.VMID, [ addr ([B), uid (0x7e0003) ] }
  [7e000b] Utf { [B }
  [7e000c] NewObject { java.rmi.dgc.VMID => { byte, ["107", "2", "-57", "114", "96", "28", "-57", "-107"], 5 => { ["short", -32767], ["long", 1416097169642], ["int", -379403840] } } }
  [7e000d] NewClassDesc { [B, [  ] }
  [7e000e] NewArray { byte, ["107", "2", "-57", "114", "96", "28", "-57", "-107"] }
  [7e000f] NewObject { 5 => { ["short", -32767], ["long", 1416097169642], ["int", -379403840] } }
]
    EOS
  }

  describe ".new" do
    it "Rex::Java::Serialization::Model::Stream" do
      expect(stream).to be_a(Rex::Java::Serialization::Model::Stream)
    end

    it "initializes magic with java serialized stream signature" do
      expect(stream.magic).to eq(Rex::Java::Serialization::STREAM_MAGIC)
    end

    it "initializes version with java serialized stream default version " do
      expect(stream.version).to eq(Rex::Java::Serialization::STREAM_VERSION)
    end

    it "initializes references as empty array " do
      expect(stream.references).to be_empty
    end

    it "initializes stream to nil by default" do
      expect(stream.stream).to be_nil
    end
  end

  describe "#decode" do
    context "when deserializing a simple Object stream" do
      it "deserializes an Stream" do
        expect(stream.decode(easy_object_stream_io)).to be_a(Rex::Java::Serialization::Model::Stream)
      end

      it "deserializes the signature correctly" do
        stream.decode(easy_object_stream_io)
        expect(stream.magic).to eq(Rex::Java::Serialization::STREAM_MAGIC)
      end

      it "deserializes all the contents" do
        stream.decode(easy_object_stream_io)
        expect(stream.contents.length).to eq(1)
      end

      it "deserializes a simple object correctly" do
        stream.decode(easy_object_stream_io)
        expect(stream.contents[0]).to be_an(Rex::Java::Serialization::Model::NewObject)
      end
    end

    context "when deserializing a char array" do
      it "deserializes an Stream" do
        expect(stream.decode(char_array_stream_io)).to be_a(Rex::Java::Serialization::Model::Stream)
      end

      it "deserializes the char array correctly" do
        stream.decode(char_array_stream_io)
        expect(stream.contents[0]).to be_an(Rex::Java::Serialization::Model::NewArray)
      end
    end

    context "when deserializing a complex stream with references" do
      it "deserializes an Stream" do
        expect(stream.decode(complex_stream_io)).to be_a(Rex::Java::Serialization::Model::Stream)
      end

      it "deserializes all the contents in the Stream" do
        stream.decode(complex_stream_io)
        expect(stream.contents.length).to eq(4)
      end

      it "deserializes object contents" do
        stream.decode(complex_stream_io)
        expect(stream.contents[3]).to be_a(Rex::Java::Serialization::Model::NewObject)
      end
    end
  end

  describe "#to_s" do
    it "prints a simple Object stream" do
      stream.decode(easy_object_stream_io)
      expect(stream.to_s).to eq(easy_object_stream_to_s)
    end

    it "prints a char array stream" do
      stream.decode(char_array_stream_io)
      expect(stream.to_s).to eq(char_array_stream_to_s)
    end

    it "prints a complex stream with references" do
      stream.decode(complex_stream_io)
      expect(stream.to_s).to eq(complex_stream_to_s)
    end
  end

  describe "#encode" do
    context "when serializing a simple Object stream" do
      it "serializes the Stream" do
        new_class_desc = Rex::Java::Serialization::Model::NewClassDesc.new
        new_class_desc.class_name = Rex::Java::Serialization::Model::Utf.new(nil, 'Easy')
        new_class_desc.serial_version = 0x741de1bcbb2fcbaa
        new_class_desc.flags = 2
        field = Rex::Java::Serialization::Model::Field.new
        field.type = 'int'
        field.name = Rex::Java::Serialization::Model::Utf.new(nil, 'SSN')
        new_class_desc.fields << field
        new_class_desc.class_annotation = Rex::Java::Serialization::Model::Annotation.new
        new_class_desc.class_annotation.contents << Rex::Java::Serialization::Model::EndBlockData.new
        new_class_desc.super_class = Rex::Java::Serialization::Model::ClassDesc.new
        new_class_desc.super_class.description = Rex::Java::Serialization::Model::NullReference.new

        new_object = Rex::Java::Serialization::Model::NewObject.new
        new_object.class_desc = Rex::Java::Serialization::Model::ClassDesc.new
        new_object.class_desc.description = new_class_desc
        new_object.class_data = [['int', 0x41424344]]

        stream.contents << new_object
        expect(stream.encode.unpack("C*")).to eq(easy_object_stream.unpack("C*"))
      end
    end

    context "when serializing a char array" do
      it "serializes the Stream" do
        new_class_desc = Rex::Java::Serialization::Model::NewClassDesc.new
        new_class_desc.class_name = Rex::Java::Serialization::Model::Utf.new(nil, '[C')
        new_class_desc.serial_version = 0xb02666b0e25d84ac
        new_class_desc.flags = 2
        new_class_desc.class_annotation = Rex::Java::Serialization::Model::Annotation.new
        new_class_desc.class_annotation.contents << Rex::Java::Serialization::Model::EndBlockData.new
        new_class_desc.super_class = Rex::Java::Serialization::Model::ClassDesc.new
        new_class_desc.super_class.description = Rex::Java::Serialization::Model::NullReference.new

        new_array = Rex::Java::Serialization::Model::NewArray.new
        new_array.array_description = Rex::Java::Serialization::Model::ClassDesc.new
        new_array.array_description.description = new_class_desc
        new_array.type = 'char'
        new_array.values = [97, 98]

        stream.contents << new_array
        expect(stream.encode.unpack("C*")).to eq(char_array_stream.unpack("C*"))
      end
    end

    context "when reserializing a complex stream" do
      it "reserializes the original stream" do
        stream.decode(complex_stream_io)
        expect(stream.encode.unpack("C*")).to eq(complex_stream.unpack("C*"))
      end
    end
  end

end